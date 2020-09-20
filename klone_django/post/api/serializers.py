from rest_framework_nested import serializers as nested_serializers
from rest_framework import serializers
from post import models
from user.api.serializers import UserSerializer


class PostSerializer(serializers.ModelSerializer):
    parent_lookup_kwargs = {
        'user_pk': 'user__pk',
    }

    user = UserSerializer(read_only=True)

    class Meta:
        model = models.Post
        fields = "__all__"

    def create(self, validated_data):
        return models.Post.objects.create(**validated_data, user=self.context['request'].user)


class LikeSerializer(serializers.ModelSerializer):
    user = UserSerializer(read_only=True)

    def create(self, validated_data):
        return models.Like.objects.create(
            post=validated_data['post'], user=self.context['request'].user)

    class Meta:
        model = models.Like
        fields = "__all__"


class CommentSerializer(serializers.ModelSerializer):
    user = UserSerializer(read_only=True)

    def create(self, validated_data):
        return models.Comment.objects.create(
            post=validated_data['post'], user=self.context['request'].user, text=validated_data['text'])

    class Meta:
        model = models.Comment
        fields = "__all__"


class FeedSerializer(serializers.ModelSerializer):
    user = UserSerializer(read_only=True)
    parent_lookup_kwargs = {
        'user_pk': 'user__pk',
    }

    class Meta:
        model = models.Post
        fields = "__all__"


class UserLikeSerializer(serializers.ModelSerializer):
    # post = PostSerializer(read_only=True)
    # user = UserSerializer(read_only=True)

    class Meta:
        model = models.Like
        fields = ("id", "post", "user")

class ActivitySerializer(serializers.ModelSerializer):
    post = PostSerializer(read_only=True)
    user = UserSerializer(read_only=True)

    class Meta:
        model = models.Like
        fields = ("id", "post", "user")
