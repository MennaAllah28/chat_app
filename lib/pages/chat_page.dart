import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants.dart';
import '../models/message.dart';
import '../widgets/chat_buble.dart';

// class ChatPage extends StatelessWidget {
//   static String id = 'ChatPage';

//   final _controller = ScrollController();

//   FirebaseFirestore firestore = FirebaseFirestore.instance;
//   CollectionReference messages =
//       FirebaseFirestore.instance.collection(KMessagesCollection);

//   TextEditingController controller = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     var email = ModalRoute.of(context)!.settings.arguments;

//     return StreamBuilder<QuerySnapshot>(
//       stream: messages.orderBy(KCreatedAt, descending: true).snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.hasData) {
//           List<Message> messagesList = [];
//           for (int i = 0; i < snapshot.data!.docs.length; i++) {
//             messagesList.add(Message.fromJson(snapshot.data!.docs[i]));
//           }
//           // for (int i = 0; i < snapshot.data!.docx.length; i++) {
//           //   messagesList.add(Message.fromJson(snapshot.data!.docx[i]));
//           // }
//           return Scaffold(
//             appBar: AppBar(
//               automaticallyImplyLeading: false,
//               backgroundColor: kPrimaryColor,
//               title: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Image.asset(
//                     KLogo,
//                     height: 50,
//                   ),
//                   Text('Chat'),
//                 ],
//               ),
//               centerTitle: true,
//             ),
//             body: Column(
//               children: [
//                 Expanded(
//                   child: ListView.builder(
//                       reverse: true,
//                       controller: _controller,
//                       itemCount: messagesList.length,
//                       itemBuilder: (context, index) {
//                         return messagesList[index].id == email
//                             ? ChatBuble(
//                                 message: messagesList[index],
//                               )
//                             : ChatBubleForFriend(message: messagesList[index]);
//                       }),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: TextField(
//                     controller: controller,
//                     onSubmitted: (data) {
//                       messages.add({
//                         KMessage: data,
//                         KCreatedAt: DateTime.now(),
//                         'id': email,
//                       });
//                       controller.clear();

//                       _controller.animateTo(
//                         0,
//                         duration: Duration(seconds: 1),
//                         curve: Curves.fastOutSlowIn,
//                       );
//                     },
//                     decoration: InputDecoration(
//                         hintText: 'Send Message',
//                         suffixIcon: Icon(
//                           Icons.send,
//                           color: kPrimaryColor,
//                         ),
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(16),
//                             borderSide: BorderSide(
//                               color: kPrimaryColor,
//                             )),
//                         enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(16),
//                             borderSide: BorderSide(color: kPrimaryColor))),
//                   ),
//                 )
//               ],
//             ),
//           );
//         } else {
//           Text('Loading...');
//         }
//         return Column(
//           children: [Text('data')],
//         );
//       },
//     );
//   }
// }

class ChatPage extends StatefulWidget {
  static String id = 'ChatPage';

  ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _controller = ScrollController();

  final CollectionReference messages =
      FirebaseFirestore.instance.collection(KMessagesCollection);

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final email = ModalRoute.of(context)!.settings.arguments;
    return StreamBuilder<QuerySnapshot>(
      stream: messages.orderBy(KCreatedAt, descending: true).snapshots(),
      builder: (context, snapshots) {
        if (snapshots.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshots.hasData) {
          return const Text('No data available right now');
        }
        print('=== data ===: ${snapshots.data!.docs}');
        List<Message> messagesList = [];
        for (int i = 0; i < snapshots.data!.docs.length; i++) {
          messagesList.add(Message.fromJson(snapshots.data!.docs[i]));
        }
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: kPrimaryColor,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  KLogo,
                  height: 50,
                ),
                const Text('chat'),
              ],
            ),
            centerTitle: true,
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                    reverse: true,
                    controller: _controller,
                    itemCount: messagesList.length,
                    itemBuilder: (context, index) {
                      return messagesList[index].id == email
                          ? ChatBuble(
                              message: messagesList[index],
                            )
                          : ChatBubleForFriend(message: messagesList[index]);
                    }),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: controller,
                  onSubmitted: (data) {
                    messages.add(
                      {KMessage: data, KCreatedAt: DateTime.now(), 'id': email},
                    );
                    controller.clear();
                    _controller.animateTo(0,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeIn);
                  },
                  decoration: InputDecoration(
                    hintText: 'Send Message',
                    suffixIcon: const Icon(
                      Icons.send,
                      color: kPrimaryColor,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
