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
As i mentioned in the previous section i 
- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
