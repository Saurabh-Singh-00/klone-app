### Klone Django
##### REST API for Photo Editing and Sharing App.

------------
### Folder Structure📂
1. First Fork the project
[Click Here for Project Link](https://github.com/Saurabh-Singh-00/klone_django.git "Klone Django Project from Here")
2. Create and navigate to a Directory named **klone** any where on your system
`mkdir klone && cd klone`
3. Clone your forked repo of the Project
`git clone https://github.com/ <`**your_user_name**`> /klone_django.git`
4. A directory called **klone_django** will be created
5. Setup the Environment now. Follow the Steps Below👇


### Environment Setup🐱‍💻
1. Install Virtual Environment
`pip install virtualenv`
2. Create Virtual Environment
`virtualenv venv`
3. Activate Virtual Environment
`venv\Scripts\activate`
4. Navigate to Project Folder 
`cd klone_django`
5. Install dependencies
`pip install -r requirements.txt`


### First Run 🏃‍♂️
1. Make Migrations
`python manage.py makemigrations`
2. Migrate Changes
`python manage.py migrate`
3. Create Superuser
`python manage.py createsuperuser`
4. Run Server
`python manage.py runserver`
