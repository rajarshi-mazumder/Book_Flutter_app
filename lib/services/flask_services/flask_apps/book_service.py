from flask import Flask, request, jsonify, Blueprint
from config import Config
from models import db, Book, Author, Category

books_service = Blueprint("services", __name__)



# app = Flask(__name__)




first_request_handled = False

@books_service.before_request
def create_tables():
    global first_request_handled
    if not first_request_handled:
        db.create_all()
        first_request_handled = True

@books_service.route('/categories', methods=['POST'])
def create_category():
    data = request.get_json()
    category_name = data['name']
    
    try:
        category = Category.query.filter_by(name=category_name).first()
        if not category:
            category = Category(name=category_name)
            db.session.add(category)
            db.session.commit()
            return jsonify({'message': 'Category created successfully'}), 201
        else:
            return jsonify({'message': 'Category already exists'}), 200
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

@books_service.route('/books', methods=['POST'])
def create_book():
    data = request.get_json()
    book_id = data['bookId']
    title = data['title']
    description = data['description']
    cover_img_path = data.get('coverImgPath')
    author_name = data['author']['name'] if data.get('author') else None
    categories_data = data.get('categories', [])

    try:
        author = None
        if author_name:
            author = Author.query.filter_by(name=author_name).first()
            if not author:
                author = Author(name=author_name)
                db.session.add(author)
                db.session.commit()

        categories = []
        for cat_data in categories_data:
            category = Category.query.filter_by(name=cat_data['name']).first()
            if not category:
                category = Category(name=cat_data['name'])
                db.session.add(category)
                db.session.commit()
            categories.append(category)

        new_book = Book(
            book_id=book_id,
            title=title,
            description=description,
            cover_img_path=cover_img_path,
            author=author
        )
        new_book.categories = categories

        db.session.add(new_book)
        db.session.commit()
        return jsonify({'message': 'Book created successfully'}), 201
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

@books_service.route('/books', methods=['GET'])
def get_books():
    books = Book.query.all()
    books_list = []
    for book in books:
        book_data = {
            'id': book.id,
            'bookId': book.book_id,
            'title': book.title,
            'description': book.description,
            'coverImgPath': book.cover_img_path,
            'author': {'name': book.author.name} if book.author else None,
            'categories': [{'name': category.name} for category in book.categories]
        }
        books_list.append(book_data)
    return jsonify(books_list)

@books_service.route('/books/<int:id>', methods=['GET'])
def get_book(id):
    book = Book.query.get_or_404(id)
    book_data = {
        'id': book.id,
        'bookId': book.book_id,
        'title': book.title,
        'description': book.description,
        'coverImgPath': book.cover_img_path,
        'author': {'name': book.author.name} if book.author else None,
        'categories': [{'name': category.name} for category in book.categories]
    }
    return jsonify(book_data)

@books_service.route('/books/<int:id>', methods=['PUT'])
def update_book(id):
    data = request.get_json()
    book = Book.query.get_or_404(id)

    book.book_id = data['bookId']
    book.title = data['title']
    book.description = data['description']
    book.cover_img_path = data.get('coverImgPath')

    author_name = data['author']['name'] if data.get('author') else None
    categories_data = data.get('categories', [])

    try:
        if author_name:
            author = Author.query.filter_by(name=author_name).first()
            if not author:
                author = Author(name=author_name)
                db.session.add(author)
                db.session.commit()
            book.author = author
        else:
            book.author = None

        categories = []
        for cat_data in categories_data:
            category = Category.query.filter_by(name=cat_data['name']).first()
            if not category:
                category = Category(name=cat_data['name'])
                db.session.add(category)
                db.session.commit()
            categories.append(category)
        book.categories = categories

        db.session.commit()
        return jsonify({'message': 'Book updated successfully'})
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

@books_service.route('/books/<int:id>', methods=['DELETE'])
def delete_book(id):
    book = Book.query.get_or_404(id)
    try:
        db.session.delete(book)
        db.session.commit()
        return jsonify({'message': 'Book deleted successfully'})
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

@books_service.route('/author', methods=['GET'])
def get_authors():
    authors = Author.query.all()
    author_list = []
    for author in authors:
        author_data = {
            'id': author.id,
            'name': author.name,
        
        }
        author_list.append(author_data)
    return jsonify(author_list)



