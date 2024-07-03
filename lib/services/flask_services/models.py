from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()


class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(50), nullable=False)
    email = db.Column(db.String(50), unique=True, nullable=False)
    password = db.Column(db.String(50), nullable=False)
    admin = db.Column(db.Boolean, default=False)
    books_read = db.relationship('Book', secondary='user_books_read', backref='users_read')
    books_started = db.relationship('Book', secondary='user_books_started', backref='users_started')
    interested_categories = db.relationship('Category', secondary='user_interested_categories', backref='interested_users')

    def __repr__(self):
        return f'<User {self.name}>'

class Author(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), unique=True, nullable=False)

    def __repr__(self):
        return f'<Author {self.name}>'

class Category(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(50), unique=True, nullable=False)

    def __repr__(self):
        return f'<Category {self.name}>'

book_category = db.Table('book_category',
    db.Column('book_id', db.Integer, db.ForeignKey('book.id'), primary_key=True),
    db.Column('category_id', db.Integer, db.ForeignKey('category.id'), primary_key=True)
)

class Book(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    book_id = db.Column(db.String(50), unique=True, nullable=False)
    title = db.Column(db.String(150), nullable=False)
    description = db.Column(db.Text, nullable=False)
    cover_img_path = db.Column(db.String(250), nullable=True)
    author_id = db.Column(db.Integer, db.ForeignKey('author.id'), nullable=True)
    author = db.relationship('Author', backref=db.backref('books', lazy=True))
    categories = db.relationship('Category', secondary=book_category, lazy='subquery',
                                 backref=db.backref('books', lazy=True))

    def __repr__(self):
        return f'<Book {self.title}>'
    
    
class UserBooksRead(db.Model):
    __tablename__ = 'user_books_read'
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), primary_key=True)
    book_id = db.Column(db.Integer, db.ForeignKey('book.id'), primary_key=True)

class UserBooksStarted(db.Model):
    __tablename__ = 'user_books_started'
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), primary_key=True)
    book_id = db.Column(db.Integer, db.ForeignKey('book.id'), primary_key=True)

class UserInterestedCategories(db.Model):
    __tablename__ = 'user_interested_categories'
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), primary_key=True)
    category_id = db.Column(db.Integer, db.ForeignKey('category.id'), primary_key=True)
