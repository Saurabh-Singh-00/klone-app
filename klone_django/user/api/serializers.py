from rest_framework_nested import serializers as nested_serializers
from rest_framework_nested.relations import NestedHyperlinkedRelatedField
from rest_framework import serializers
from rest_framework.authtoken.models import Token
from user import models
from rest_framework.request import Request
from rest_auth.registration.serializers import RegisterSerializer as RESTRegisterSerializer


class UserProfileSerializer(serializers.ModelSerializer):
    # url = NestedHyperlinkedRelatedField(
    #     view_name='profile-detail', lookup_field='user', read_only=True)
    parent_lookup_kwargs = {
        'user_pk': 'user__pk'
    }

    class Meta:
        model = models.UserProfile
        fields = ("id", "followers_count", "following_count",
                  "profile_picture", "posts_count", "is_public")


class UserSerializer(serializers.ModelSerializer):
    profile = UserProfileSerializer(read_only=True)

    class Meta:
        model = models.User
        fields = ("id", "username", "first_name", "last_name",
                  "password", "email", "dob", "profile")
        extra_kwargs = {'password': {'write_only': True}}

    def create(self, validated_data):
        user = models.User(**validated_data)
        user.set_password(validated_data['password'])
        user.save()
        return user


class RegisterSerializer(RESTRegisterSerializer):
    first_name = serializers.CharField()
    last_name = serializers.CharField()

    def get_cleaned_data(self):
        super().get_cleaned_data()
        return {
            'username': self.validated_data.get('username', ''),
            'password1': self.validated_data.get('password1', ''),
            'password2': self.validated_data.get('password2', ''),
            'email': self.validated_data.get('email', ''),
            'first_name': self.validated_data.get('first_name', ''),
            'last_name': self.validated_data.get('last_name', '')
        }


class FollowerSerializer(serializers.ModelSerializer):

    follower = UserSerializer(read_only=True)
    # followee = UserSerializer(read_only=True)

    def create(self, validated_data):
        json = self.context['request'].data
        followee = models.User.objects.get(id=json['followee'])
        follower = self.context['request'].user
        return models.Following.objects.create(followee=followee, follower=follower)

    class Meta:
        model = models.Following
        fields = ("id", "follower", "followee")


class FollowingSerializer(serializers.ModelSerializer):
    followee = UserSerializer(read_only=True)
    # followee = UserSerializer(read_only=True)

    class Meta:
        model = models.Following
        fields = ("id", "followee", "follower")


class SearchSerializer(serializers.ModelSerializer):
    profile = UserProfileSerializer(read_only=True)

    class Meta:
        model = models.User
        fields = ("id", "username", "first_name", "last_name",
                  "email", "dob", "profile")
