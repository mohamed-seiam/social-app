class SocialPostModel
{
  String ? name;
  String ? uId;
  String ? image ;
  String ? dateTime;
  String ? postImage;
  String ? text;

  SocialPostModel({

    this.dateTime,
    this.postImage,
    this.name,
    this.uId,
    this.text,
    this.image,
  });

  SocialPostModel.fromjson(Map<String,dynamic>json)
  {
    dateTime  =  json['dateTime'];
    text = json['text'];
    name = json['name'];
    uId = json['uId'];
    postImage = json['postImage'];
    image = json['image'];

  }

  Map<String,dynamic> tomap()
  {
    return
      {
        'name' : name,
        'dateTime' : dateTime,
        'uId' : uId,
        'text':text,
        'postImage':postImage,
        'image':image,
      };
  }
}