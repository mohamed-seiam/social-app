import 'package:flutter/material.dart';
import '../../../models/comment_model.dart';
import '../helper_time_foramt.dart';

class CommentItem extends StatefulWidget {
  const CommentItem({
    Key? key,
    required this.commentModel,
  }) : super(key: key);
  final CommentModel commentModel;

  @override
  State<CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(widget.commentModel.imageOfCommentor),
          ),
          const SizedBox(
            width: 6,
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(
                      top: 5, bottom: 5, left: 10, right: 10),
                  margin: const EdgeInsets.only(top: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400.withOpacity(.5),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(18),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.commentModel.nameOfCommentor,
                          style: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w500),
                          textAlign: TextAlign.justify),
                      const SizedBox(
                        height: 3,
                      ),
                      if (widget.commentModel.comment.isNotEmpty)
                        Text(
                          widget.commentModel.comment,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                          ),
                        ),
                    ],
                  ),
                ),
                if (widget.commentModel.commentImage != '')
                  const SizedBox(
                    height: 10,
                  ),
                if (widget.commentModel.commentImage != '')
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image(
                      image: NetworkImage(widget.commentModel.commentImage),
                      fit: BoxFit.contain,
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace? stackTrace) {
                        return Container(
                          height: 150,
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.only(top: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: const BorderRadius.all(
                              Radius.circular(18),
                            ),
                          ),
                          child: const Center(child: Icon(Icons.error),),
                        );
                      },
                    ),
                  ),
                const SizedBox(
                  height: 3,
                ),
                Text(
                  FacebookCommentFormatter.formatTimestamp(
                      widget.commentModel.timeOfComment),
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
