class SocialUserModel
{
    String ? email;
    String ? phone;
    String ? name;
    String ? uId;
    bool ? isEmailVerified;
    String ? image ;
    String ? cover;
    String ? bio;

  SocialUserModel({

  this.email,
  this.phone,
  this.name,
  this.uId,
  this.isEmailVerified,
  this.cover,
  this.image,
    this.bio,

});

    SocialUserModel.fromjson(Map<String,dynamic>json)
  {
    email  =  json['email'];
    phone = json['phone'];
    name = json['name'];
    uId = json['uId'];
    isEmailVerified = json['isEmailVerified'];
    cover = json['cover'];
    image = json['image'];
    bio = json['bio'];

  }

  Map<String,dynamic> tomap()
  {
    return
      {
        'name' : name,
        'phone': phone,
        'email' : email,
        'uId' : uId,
        'isEmailVerified':isEmailVerified,
        'cover':cover,
        'image':image,
        'bio':bio,
      };
  }
}