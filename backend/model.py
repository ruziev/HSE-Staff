from pony import orm
import hashlib

db = orm.Database()

class MD5:

    def encode(string):
        m = hashlib.md5()
        m.update(string.encode())
        return m.hexdigest()

class HelpingFunctions:
    @orm.db_session
    def createAdminIfNeeded():
        if not list(orm.select(u for u in User)):
            User(name="admin", passwordHash=MD5.encode("admin"))


class GlobalData:
    currentUser = None

class Person(db.Entity):
    name = orm.Required(str)
    page = orm.Required(str)
    phone = orm.Optional(str)
    email = orm.Optional(str)
    photo = orm.Optional(str)
    address = orm.Optional(str)

    def __str__(self):
        return "<Person: {name}>".format(name=self.name)

    def __repr__(self):
        return "<Person: {name}>".format(name=self.name)

    def toDict(self):
        return dict(
            id=self.id,
            name=self.name,
            page=self.page if 'hse.ru' in self.page else 'http://hse.ru/'+self.page,
            phone=self.phone,
            email=self.email,
            photo=self.photo if 'hse.ru' in self.photo else 'http://hse.ru/'+self.photo,
            address=self.address
        )

class User(db.Entity):
    name = orm.Required(str)
    passwordHash = orm.Required(str)

db.bind('sqlite', "persons.sqlite")
db.generate_mapping(create_tables=True)