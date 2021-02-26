import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:whoru/src/data/chat.dart';
import 'package:whoru/src/pages/chat/widgets/active_friend_card.dart';
import 'package:whoru/src/pages/home/widgets/horizontal_user.dart';
import 'package:whoru/src/pages/home/widgets/post_card.dart';

import '../../common/styles.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mC,
        elevation: .0,
        title: GestureDetector(
          onTap: () => Get.offAndToNamed('/root'),
          child: Text(
            'Whoru',
            style: TextStyle(
              color: colorTitle,
              fontFamily: 'Lobster',
              fontWeight: FontWeight.w400,
              fontSize: _size.width / 16.0,
            ),
          ),
        ),
        actions: [
          _buildActionHome(context, 'Camera', Feather.camera),
          SizedBox(width: 12.0),
          _buildActionHome(context, 'Camera', Feather.align_justify),
          SizedBox(width: 10.0),
        ],
      ),
      body: Container(
        color: mC,
        child: Column(
          children: [
            SizedBox(height: 10.0),
            Expanded(
              child: NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (overscroll) {
                  overscroll.disallowGlow();
                  return true;
                },
                child: ListView.builder(
                  controller: _scrollController,
                  physics: ClampingScrollPhysics(),
                  padding: EdgeInsets.only(top: .0),
                  itemCount: 12,
                  itemBuilder: (context, index) {
                    return index == 0
                        ? _buildActiveFriend(context)
                        : index == 2
                            ? HorizontalUser()
                            : PostCard();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionHome(context, title, icon) {
    final _size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.all(16.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: mC,
        boxShadow: [
          BoxShadow(
            color: mCD,
            offset: Offset(2, 2),
            blurRadius: 2,
          ),
          BoxShadow(
            color: mCL,
            offset: Offset(-2, -2),
            blurRadius: 2,
          ),
        ],
      ),
      child: Icon(
        icon,
        color: colorDarkGrey,
        size: _size.width / 20.5,
      ),
    );
  }

  Widget _buildActiveFriend(context) {
    final _size = MediaQuery.of(context).size;
    return Container(
      color: mC,
      child: Column(
        children: [
          Container(
            height: _size.width * .225,
            width: _size.width,
            padding: EdgeInsets.only(left: 16.0, right: 4.0),
            child: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (overscroll) {
                overscroll.disallowGlow();
                return true;
              },
              child: ListView.builder(
                physics: ClampingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: chats.length,
                itemBuilder: (context, index) {
                  return ActiveFriendCard(
                    urlToImage: chats[index].image,
                    fullName: chats[index].fullName,
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 16.0, bottom: 2.0),
            child: Divider(
              height: .2,
              thickness: .2,
              color: mCH,
            ),
          ),
        ],
      ),
    );
  }
}
