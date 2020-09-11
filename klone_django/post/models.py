from django.db import models
from django.db.models import F
from user.models import User, UserProfile
from PIL import Image


def USER_DIRECTORY_PATH(
    instance, image): return "user_{}/{}".format(instance.user.id, image)


class Post(models.Model):
    user = models.ForeignKey(
        User, on_delete=models.CASCADE, related_name='post')
    image = models.ImageField(
        upload_to=USER_DIRECTORY_PATH, blank=False, null=False)
    caption = models.CharField(max_length=1000, blank=True, null=True)
    likes_count = models.IntegerField(default=0)
    comments_count = models.IntegerField(default=0)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.user.username + " - {}".format(self.id)


class Like(models.Model):
    post = models.ForeignKey(
        Post, on_delete=models.CASCADE, related_name='like')
    user = models.ForeignKey(
        User, on_delete=models.CASCADE, related_name='like')

    def __str__(self):
        return str(self.post)


class Comment(models.Model):
    post = models.ForeignKey(
        Post, on_delete=models.CASCADE, related_name='comment')
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='comment')
    text = models.CharField(max_length=1000)
    date_time = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return str(self.post) + " - Commented by " + self.user.username
