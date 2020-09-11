from django.db.models.signals import post_save, post_delete
from post.models import Post, Comment, Like
from django.dispatch import receiver
from user.models import UserProfile
from django.db.models import F


@receiver(post_save, sender=Post)
def post_is_created(sender, instance, created, **kwargs):
    if created:
        user = UserProfile.objects.get(user__id=instance.user.id)
        user.posts_count = F('posts_count') + 1
        user.save()


@receiver(post_delete, sender=Post)
def post_is_deleted(sender, instance, **kwargs):
    user = UserProfile.objects.get(user__id=instance.user.id)
    user.posts_count = F('posts_count') - 1
    user.save()


@receiver(post_save, sender=Like)
def like_is_created(sender, instance, created, **kwargs):
    if created:
        Post.objects.filter(id=instance.post.id).update(
            likes_count=F('likes_count')+1)


@receiver(post_delete, sender=Like)
def like_is_deleted(sender, instance, **kwargs):
    Post.objects.filter(id=instance.post.id).update(
        likes_count=F('likes_count')-1)


@receiver(post_save, sender=Comment)
def comment_is_created(sender, instance, created, **kwargs):
    if created:
        Post.objects.filter(id=instance.post.id).update(
            comments_count=F('comments_count')+1)


@receiver(post_delete, sender=Comment)
def comment_is_deleted(sender, instance, **kwargs):
    Post.objects.filter(id=instance.post.id).update(
        comments_count=F('comments_count')-1)
