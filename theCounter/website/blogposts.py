from flask import Blueprint, render_template, request, flash, redirect, url_for, jsonify
from flask_login import login_required, current_user
from .models import Blogpost
from . import db
import json
import datetime

blogposts = Blueprint('blogposts', __name__)

@blogposts.route('/blogposts', methods=['GET', 'POST'])
@login_required
def blogposts_home():
    blogposts_ = []
    return render_template('blogposts.html', user=current_user, blogposts=blogposts_)

@blogposts.route('/add-blogpost', methods=['GET', 'POST'])
@login_required
def add_blogpost():
    
    return render_template('new_blogpost.html', user=current_user)

@blogposts.route('/blogpost/<int:id>', methods=['GET'])
@login_required
def view_blogpost(id):
    try:
        num_id = int(id)
    except:
        flash("Invalid ID", category="error")
        return redirect(url_for("blogposts.blogposts_home"))
    blogpost_ = Blogpost.get_from_id(num_id)
    if blogpost_ is None:
        flash("Blog not found", category="error")
        return redirect(url_for("blogposts.blogposts_home"))
    
    return render_template('view_blogpost.html', user=current_user, blogpost=blogpost_)