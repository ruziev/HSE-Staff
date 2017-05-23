from flask import Flask, render_template, request, Response, abort
from functools import wraps
from pony import orm
from model import Person, User, GlobalData, HelpingFunctions, MD5
from json import dumps

app = Flask(__name__)


@orm.db_session
def check_auth(username, password):
    matchedUsers = orm.select(u for u in User if u.name == username and u.passwordHash.lower() == MD5.encode(password).lower())
    #print(username, password, list(matchedUsers), MD5.encode(password))
    if not list(matchedUsers):
        return False
    GlobalData.currentUser = list(matchedUsers)[0]
    return True

def authenticate():
    return Response(
    'Could not verify your access level for that URL.\n'
    'You have to login with proper credentials', 401,
    {'WWW-Authenticate': 'Basic realm="Login Required"'})

def requires_auth(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        auth = request.authorization
        if not auth or not check_auth(auth.username, auth.password):
            return authenticate()
        return f(*args, **kwargs)
    return decorated


@app.route("/")
@app.route('/search')
@orm.db_session
def search():
    nameQuery = request.args.get('nameQuery',"")
    emailQuery = request.args.get('emailQuery',"")
    return render_template("index.html",
                           results=list(orm.select(p for p in Person
                                    if nameQuery in p.name.lower() and
                                    emailQuery in p.email)))

@app.route('/allJSON')
@requires_auth
@orm.db_session
def allJson():
    return dumps(list(map(Person.toDict, orm.select(p for p in Person))))


@app.route("/staff/<int:personId>")
@orm.db_session
def staffPage(personId):
    person = Person[personId]
    if "hse.ru" not in person.photo:
        person.photo = "http://hse.ru"+person.photo
    return render_template("personPage.html",
                           person=person)

@app.route("/user/create")
@requires_auth
@orm.db_session
def createUser():
    params = request.args
    try:
        name = params['name']
        passwordHash = params['passwordHash']
        User(name=name, passwordHash=passwordHash)
        return "Success"
    except:
        return abort(400)

@app.route("/user/update")
@requires_auth
@orm.db_session
def updateUser():
    params = request.args
    message = ""
    if 'newName' in params:
        #GlobalData.currentUser.name = params['newName']
        User[GlobalData.currentUser.id].name = params['newName']
        message += "name set "
    if 'newPasswordHash' in params:
        #GlobalData.currentUser.passwordHash = params['newPasswordHash']
        User[GlobalData.currentUser.id].passwordHash = params['newPasswordHash']
        message += "password set"
    return message or "no changes"

@app.route("/user/delete")
@requires_auth
@orm.db_session
def deleteUser():
    sure = request.args.get('sure') == "DEADSURE"
    if sure:
        User[GlobalData.currentUser.id].delete()
        return 'deleted'
    return 'not deleted'


@app.route("/staff/create")
@requires_auth
@orm.db_session
def createStaff():
    params = request.args
    name = params["name"]
    page = params["page"]
    phone = params.get("phone","")
    email = params.get("email","")
    photo = params.get("photo","")
    address = params.get("address","")

    newStaff = Person(name=name, page=page, phone=phone, email=email, photo=photo, address=address)
    return dumps(newStaff.toDict())

@app.route("/staff/<staff_id>/update")
@requires_auth
@orm.db_session
def updateStaff(staff_id):
    params = request.args
    name = params.get("name")
    page = params.get("page")
    phone = params.get("phone")
    email = params.get("email")
    photo = params.get("photo")
    address = params.get("address")

    if name:
        Person[staff_id].name = name
    if page:
        Person[staff_id].page = page
    if phone:
        Person[staff_id].phone = phone
    if email:
        Person[staff_id].email = email
    if photo:
        Person[staff_id].photo = photo
    if address:
        Person[staff_id].address = address

    return dumps(Person[staff_id].toDict())

@app.route("/staff/<staff_id>/delete")
@requires_auth
@orm.db_session
def deleteStaff(staff_id):
    sure = request.args.get('sure') == "DEADSURE"
    if sure:
        old = Person[staff_id]
        Person[staff_id].delete()
        return dumps(old.toDict())
    else:
        return 'not deleted'

@app.route("/debug")
@orm.db_session
def debug():
    return str(
        list( orm.select((u.name, u.passwordHash) for u in User) )
    )


if __name__ == '__main__':
    app.debug = True
    HelpingFunctions.createAdminIfNeeded()
    app.run()
