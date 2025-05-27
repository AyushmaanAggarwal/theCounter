# Onboarding to the Physicsquad Website!

## Branch Explanation 
Each person has a personal branch with their first name, lowercase. This is meant for making experimental changes to your version of the code. 

Then there is the main branch, which contains the most up to date version of the shared code. Once your code is all ready after you tested it, you can create a pull request on [github.com](github.com) from your personal branch to the main branch. This will then get reviewed and merged into main.

After more testing, the code will eventually be merged into live which contains the code being used by the server in production!

## Guide to Git
Once you install git, you can [set up ssh](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent) and add [the ssh key to github](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account)

Then setup your information with git on your terminal
```sh
git config --global user.name <github.com username>
git config --global user.email <github.com email>
```

You can then clone the repo
```sh
git clone git@github.com:AyushmaanAggarwal/theCounter.git
```

To enter the folder, type
```sh
cd theCounter
```

In order to change into your personal branch, and pull any changes from the main branch into your branch.
```sh
git checkout <personal-branch-name>
git merge main
```

In order to install the latest dependencies, it's recommended to install the packages in a virtual environment
```sh
# Create a virtual python virtual environment 
python -m venv venv

# Enter the virtual environment
## For Linux and MacOS
source venv/bin/activate
## For Windows
venv\Scripts\activate.bat

#Install the latest versions 
pip install -e .
```

If you made some changes to the code and want to commit the changes to your personal branch, run the following
```sh
# Add the changes to your current folder
git add .
# Commit the changes with a message to your personal branch
git commit
# Send any changes to github.com 
git push
```
