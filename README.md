# Streamy

A communication based app where you can either chat with friends or do a live call either Audio/Video ,    
I will try to demonstrate how the app works and the thought process along.  

> [!NOTE]
> **This project is considered as my playground project where i can learn how these features work and test implementation process** 

Before we start let's see a demo on how the app works.

## Getting Started

This application was made using Flutter framework and Firebase "Backend-as-a-Service" .

Before I talk about the chat flow let me discuss how the chat room is created  

![image](https://github.com/user-attachments/assets/519d3a69-a2f0-4a48-98ed-ff48b2e29a42)


Chat room is a collection of room documents with each document contatins collection of messages "which in the case of firebase is Documents" ,   
Each chat room between 2 users is a document.  
### But how i can access a certain chat room between me and certain user "John" ?
let's say my user id is "Abc123" and john id is "Doe321",   
the document name that i want to access will be named as a combination of both ids so it will be "Abc123_Doe321" in general  "myUserid_recipientUserid"  
but here's the catch :  
if john  tried to access our room following the general convention ,the document john will acess is "Doe321_Abc123" which is a different chat room   
so in order to avoid contradiciton both sender and receiver ids must be **sorted** each time so in our case either me or john when we try to access the document it will be  "Abc123_Doe321"

### Now for the read , unseen status and last message sent :  

![WhatsApp Image 2024-12-16 at 4 54 59 AM (1)](https://github.com/user-attachments/assets/eb2f78a3-9ea4-47df-a1dd-59511c014eba)   ![WhatsApp Image 2024-12-16 at 4 54 59 AM](https://github.com/user-attachments/assets/5a9cc2ed-fde3-46b6-8cd0-b0818a063977)



as mentioned in the preivous section chat room between 2 users is a document contating a collection of messages , so in order to make use of that document we have a stats on these 2 users like :-
- what is the last message sent to display on the home screen.
- who sent the last message.
- how many messages did the recipient miss.

Here's how it looks like in firebase.

![image](https://github.com/user-attachments/assets/948c04f2-e295-42f6-8bff-887b14dddff6)

Now for the exciting part , How to interact with messages collection or as i like to say  
## Chat Flow 

> [!NOTE]
> Chat flow is: Read/Write messages , How to interact with Old/New messages .  

The main purpose of this learning journey was learning webRtc to implement Audio/Video call not giving much attention about chat ,   
But later on i found that i was wrong , here's why.

During my journey with this project , I found that there 4 approaches for the chat flow which i will discuss each in the next section
1. Stream approach
2. Paginated-Stream approach 
3. Cache approach
4. Notification approach

## 1. Stream approach  
This was the first iteration of the chat implementation inside this app,   
once you enter chat room stream is opened listening to the messages collection,  
so the older messages is loaded and if the user write a new message the other user will receive immediately.    


at first this might seem like valid approach , as i was testing with 10-15 messages and it worked well :+1:    
But what if the chat contains 1k messages that will be 1k reads on Firebase, what if 10k,20k check your own average chat with a friend for example     
what if rejoined the room that's another dozens of reads, imagine how many reads !! or better not :skull_and_crossbones:

As i mentioned before i was targeting Audio/Video feature rather than focusing on chat but this approach didn't seem right at all.

### Does that mean this approach is usesless?  
No, here's when you can use it.  
- Building live-stream application : consider chat in Twitch App , you don't want to cache every message a viewer send nor you care about the number of messages sent ,
you just stream viewer messages once a viewer send one.
- Delivery chat: imagine a order delivery process and there's a chat between the customer-driver , using this approach doesn't hurt much in this case.

This approach might be useful in some cases, But not in my case .
Which why i came around with second approach.    


## 2. Paginated-Stream approach   
This is the current chat flow for Streamy .

This approach consists of 3 parts:-
- reading old messages
- updating with new messages
- current messages "least number of messages you can see when you enter the chat room"

so the idea seems straight forward , once you enter the chat room :
1- get certain number of messages
2- open stream listener to get any new messages
and if you want to load the older messages i use pagination , so when i reach the top of the screen i load another 15 messages and so on .

Implementing this wasn't easy at first but it paid off later decreasing the number of reads per chat view, 
from hundreds per chat view to maybe 15 if i wasn't curious about older messages, Sounds like a fair deal,  it was fun experience after all.    

Thinking about that approach and how i cracked the code for chat flow, I was curious about how the daily chat apps works, 
Starting with **Messenger** finding out the it worked the same way i implemented it.     
getting bunch of messages , paginate older messages if needed and so on stream new updates but when i disconnect the internet and go on chat room i can still see the first couple of messeages when no connection.    
For **Whatsapp** and **Telegram** i tried the same experiment, disconnect internet connection and check the chat and i found that all messages was still there even in old chats up to the first messages sent
and thats how i found about


## 3. Cache approach  
So loading the same old messages each time doesn't seem like a solid plan, maybe just read the changes if necessary like delete/edit message.  
As i mentioned in the previous section unlike Messenger not other apps like **Whatsapp**/**Telegram** paginate older messages from the backend side, but from the Cache storage.  
it seems like once you receive a new message you store it then retrieve it from your local storage when needed again.    

pretty straight forward ,so now they just store it locally on device's storage and on a backend server as well to check out for new messages ,right?  
It seemed like that's how it works until i scrolled up on a random chat on **Whatsapp** and found this 


![WhatsApp Image 2024-12-17 at 6 34 31 AM](https://github.com/user-attachments/assets/08f51f2a-1619-4d1d-ae82-6a8cf67d4566)  


unless you enable backup storage , no one has access on your messages except you and the recipient due to privacy concerns as mentioned in this [Blog](https://messengernews.fb.com/2024/03/28/end-to-end-encryption-what-you-need-to-know/) .   

So how does writing new messages will work? moving on to next approach .    


## 4. Notification approach  

Talking about chat without notifications seems weird enough, we don't usually check new messages by opening up the app itself then checking out each chat instead of that we get notified.  

Before we dive into this approach , we need to know first how does Notification works.  

Notifications consists of 2 main parts:
1. Receiving data "FCM"
2. Display data  "UI Notifications Packages"

when you send a notification to a device the first thing you receive is data "Payload" which contains the data iteself and decide whether you want to display it or not,  
then afterwards all you have to do is display that data you received as a Notification UI.

Following the previous approach sending new messages can be done using Notification payload itself then extract that payload to display message and store it locally .

### But what if the notifications is disabled ?  
Trying to disable notifications will only disable the the display part "UI" but doesn't contradict with Firebase Messaging "FCM" which means that you still receive data but you can't display it as a Notification.    

Didn't test this approach much as in theory it might work well , even when the device itself is in offline state once you reconnect you receive those notifications.
But depending only on notification payload doesn't seem fine   

![image](https://github.com/user-attachments/assets/983843a2-9e5d-4a2f-ab6a-48bc6c5599b8)  
[FireBase docs](https://firebase.google.com/docs/cloud-messaging)

Message might not exceed that limit as you won't send huge data like Image/Video data,   
but instead  you send a String message and if you want to send Image/Video message you just send a refrence where you can download those .  


## Conclusion   

I consider those as raw approaches , I won't consider any of those to be the best solution for a chat flow.  
Chats usually doesn't work with only one of these but with a mix between them .  

Also depending on the project you are working on and the limitations you have , desiging your own flow  will serve you the best  


