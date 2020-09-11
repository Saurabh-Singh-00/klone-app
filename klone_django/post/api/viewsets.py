from rest_framework import viewsets, permissions
from . import serializers
from post import models
from user.models import Following
from rest_framework.response import Response


class PostViewSet(viewsets.ModelViewSet):
    serializer_class = serializers.PostSerializer
    queryset = models.Post.objects.all()
    permission_classes = [permissions.IsAuthenticatedOrReadOnly, ]

    def get_queryset(self, *args, **kwargs):        
        return models.Post.objects.filter(user=self.kwargs['user_pk']).order_by("-created_at")


class CommentViewSet(viewsets.ModelViewSet):
    serializer_class = serializers.CommentSerializer
    permission_classes = (permissions.IsAuthenticated,)

    def get_queryset(self):
        return models.Comment.objects.filter(post__pk=self.kwargs['post_pk'])


class LikeViewSet(viewsets.ModelViewSet):
    serializer_class = serializers.LikeSerializer
    permission_classes = (permissions.IsAuthenticated,)

    def get_queryset(self):
        return models.Like.objects.filter(post__pk=self.kwargs['post_pk'])


class FeedsViewSet(viewsets.ModelViewSet):
    serializer_class = serializers.FeedSerializer
    permission_classes = (permissions.IsAuthenticated,)

    def get_queryset(self):
        return models.Post.objects.filter(user__pk__in=Following.objects.filter(followee=self.request.user).values_list('follower')).order_by("-created_at")


class UserLikeViewSet(viewsets.ModelViewSet):
    serializer_class = serializers.UserLikeSerializer
    permission_classes = (permissions.IsAuthenticated,)

    def get_queryset(self, *args, **kwargs):
        return models.Like.objects.filter(user=self.request.user)


class ExploreViewSet(viewsets.ModelViewSet):
    serializer_class = serializers.PostSerializer
    permission_classes = (permissions.IsAuthenticated,)

    def get_queryset(self, *args, **kwargs):
        return models.Post.objects.all().exclude(user=self.request.user)
