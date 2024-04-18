import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis_auth/googleapis_auth.dart';
class AccessTokenFirebase{
  static String firebaseMessagingScope= "https://www.googleapis.com/auth/firebase.messaging" ;
  Future<String> getAccessToken()async{
    final client = await clientViaServiceAccount(ServiceAccountCredentials.fromJson(
          {  "type": "service_account",
            "project_id": "streamy-c5eb9",
            "private_key_id": "693f3e3f8f0e32e13b5cb990fc6c7a3cca5f505e",
            "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQDSklBPqLangEaC\n6cYZjaLqwkQ4aulxzXM2FOSulaWl/2Iv6md/3dJIPvZ1C75zd1Of0YC9L+3hQPMK\nAud3lIRUHY2eAX6uQcMNcs67O4o9EjIvyhBpF2YmX9CHaNdR/cHr4UQCIVoSdscG\nMbuM/rloSCdD8HR5LlFSv1wP1TM+ZOTXQV+FDE9DmgTJI5nlxDgNBfgfwtFdl3k/\nt5y/blwhW2KY6URaLUqAwpk3dXgANsbNsz4NtWUr9P+p4L+6JKfMAfI7Vmy+sk/Q\nBBh6wTRDsZnG6jqU0pphjtdOWnAaohSqxMO7Mqrkwtl0cSCJPCjGazZKx0rnk01o\nfH33TJULAgMBAAECggEAHi1czXBoLizKg3ly6/eUk7X1O+v1JQY6DtPuCqfPSQZc\nBnI+lKBwF0LQDunOHf3Jt2Y5X844y6bYuHm+aAXvSZ9rS8ElbAi9pjWVXgIu514D\ntj3sSHtTfDK6uk/dR9ao43VG9Kfd9jZygwyT4dAhjHSGuAxY94Lv9v64orDoZUui\nwtQdBroxSrVirVnvhTMcfqPvRWCWCN0aoPErpwI/hQxkq9z9WlX0DV7kOFKRBvia\n6xv3mes5rGMCnw+JfqfmTiExo2UZSxBHg0IW6k2b0SYJt/7kf/+ObfkF0l/6sTvv\nwGNW6o1LIlYqUStpQ4D2K5zCqFc0LBIrU1y/hSSUuQKBgQDrarwlnImXjOtdD0Gd\n5LrhExHmNVrisvrc6fTSq+hAWvJrpN+BMLfARexG2JqBzgz/+iFO+l4A0wR8x4kc\n+5+CAnJinOJd7ft6S8biWuMCuyOaHWP10CJKgQNnJkfGcsuyGGcbx7212/tBfvTX\nJJwwji4Pj6TpOfmEdiOyXTmO6QKBgQDk+3jOPUOapZ+vbJorvr++6cT0XYiIpVH2\ntm2LuwrEL7uE9ovAxczS3WORfvJm7cphiygRRIkUGuJtqtkJIQPpJ2WQjpC2ldVE\nyDubjelyf1dgDgfevXt443+xBp7jR5hJE+x+8jhVQ+jaCvr1scYGPcPJq0wf+1rd\nlESljeyT0wKBgHQgSn8jIJwpX1CgXfXNBoJQLdwpJZP+RdEDd0kUk5RrSHng8n9/\n0KR/2XV5E35EbhU3BYc36XbuoKAMrY4mcSBopJQQX3mGEy7YglrWCnUmawFyzgRL\njx7BVTRkpbM2nVRUxUfm16YFxYMhZRVbcdBh0kbKzMZfWr4EqMcrRWFBAoGAPYAV\nKD9oIucNBo7CsbEfyuT6ky9z9k+AviStM3RfJeY0FTgqvPHjW1c+4NsZu+9uBdjc\nQBcKQi4eVpomhL8rT7nXG4ZO89s2Vqz45YSuCKSPEStzja2SthtUNnWywxR9oFML\nl+TyoGQG7Fk6ojbHGvIH3eh2H7jg5NZnwZdmzSUCgYBsG+rZhFChqgw28ck1fl0u\n+q3yPyzq94wOn++T9RNUce68+A4mglSKs3posK5cDm6ndSEfayWD6tbzcfJLuV8K\n5VLpTLZAy7TiuQi/X2OUCCM2r7+47dyrFogS05RlBiIc4XO0cXb22xrUmqzSNpVB\nL9hbTwhDIpS88Bfo5hDAjQ==\n-----END PRIVATE KEY-----\n",
            "client_email": "firebase-adminsdk-l1afa@streamy-c5eb9.iam.gserviceaccount.com",
            "client_id": "116727406919045137350",
            "auth_uri": "https://accounts.google.com/o/oauth2/auth",
            "token_uri": "https://oauth2.googleapis.com/token",
            "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
            "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-l1afa%40streamy-c5eb9.iam.gserviceaccount.com",
            "universe_domain": "googleapis.com"
          },
    ),[firebaseMessagingScope]
    );
    final accessToken = client.credentials.accessToken.data;
    print("access token is $accessToken");
    return accessToken;
  }

}


