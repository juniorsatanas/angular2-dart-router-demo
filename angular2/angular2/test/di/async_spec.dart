library angular2.test.di.async_spec;

import "package:angular2/test_lib.dart"
    show
        AsyncTestCompleter,
        beforeEach,
        ddescribe,
        describe,
        expect,
        iit,
        inject,
        it,
        xit;
import "package:angular2/di.dart" show Injector, bind, Key;
import "package:angular2/src/di/annotations_impl.dart"
    show Inject, InjectPromise;
import "package:angular2/src/facade/async.dart" show Future, PromiseWrapper;

class UserList {}
fetchUsers() {
  return PromiseWrapper.resolve(new UserList());
}
class SynchronousUserList {}
class UserController {
  UserList list;
  UserController(UserList list) {
    this.list = list;
  }
}
class AsyncUserController {
  var userList;
  AsyncUserController(@InjectPromise(UserList) userList) {
    this.userList = userList;
  }
}
main() {
  describe("async injection", () {
    describe("asyncGet", () {
      it("should return a promise", () {
        var injector = Injector
            .resolveAndCreate([bind(UserList).toAsyncFactory(fetchUsers)]);
        var p = injector.asyncGet(UserList);
        expect(p).toBePromise();
      });
      it("should return a promise when the binding is sync", () {
        var injector = Injector.resolveAndCreate([SynchronousUserList]);
        var p = injector.asyncGet(SynchronousUserList);
        expect(p).toBePromise();
      });
      it("should return a promise when the binding is sync (from cache)", () {
        var injector = Injector.resolveAndCreate([UserList]);
        expect(injector.get(UserList)).toBeAnInstanceOf(UserList);
        expect(injector.asyncGet(UserList)).toBePromise();
      });
      it("should return the injector", inject([AsyncTestCompleter], (async) {
        var injector = Injector.resolveAndCreate([]);
        var p = injector.asyncGet(Injector);
        p.then((injector) {
          expect(injector).toBe(injector);
          async.done();
        });
      }));
      it("should return a promise when instantiating a sync binding " +
          "with an async dependency", inject([AsyncTestCompleter], (async) {
        var injector = Injector.resolveAndCreate(
            [bind(UserList).toAsyncFactory(fetchUsers), UserController]);
        injector.asyncGet(UserController).then((userController) {
          expect(userController).toBeAnInstanceOf(UserController);
          expect(userController.list).toBeAnInstanceOf(UserList);
          async.done();
        });
      }));
      it("should create only one instance (async + async)", inject(
          [AsyncTestCompleter], (async) {
        var injector = Injector
            .resolveAndCreate([bind(UserList).toAsyncFactory(fetchUsers)]);
        var ul1 = injector.asyncGet(UserList);
        var ul2 = injector.asyncGet(UserList);
        PromiseWrapper.all([ul1, ul2]).then((uls) {
          expect(uls[0]).toBe(uls[1]);
          async.done();
        });
      }));
      it("should create only one instance (sync + async)", inject(
          [AsyncTestCompleter], (async) {
        var injector = Injector.resolveAndCreate([UserList]);
        var promise = injector.asyncGet(UserList);
        var ul = injector.get(UserList);
        expect(promise).toBePromise();
        expect(ul).toBeAnInstanceOf(UserList);
        promise.then((ful) {
          expect(ful).toBe(ul);
          async.done();
        });
      }));
      it("should show the full path when error happens in a constructor",
          inject([AsyncTestCompleter], (async) {
        var injector = Injector.resolveAndCreate([
          UserController,
          bind(UserList).toAsyncFactory(() {
            throw "Broken UserList";
          })
        ]);
        var promise = injector.asyncGet(UserController);
        PromiseWrapper.then(promise, null, (e) {
          expect(e.message).toContain(
              "Error during instantiation of UserList! (UserController -> UserList)");
          async.done();
        });
      }));
    });
    describe("get", () {
      it("should throw when instantiating an async binding", () {
        var injector = Injector
            .resolveAndCreate([bind(UserList).toAsyncFactory(fetchUsers)]);
        expect(() => injector.get(UserList)).toThrowError(
            "Cannot instantiate UserList synchronously. It is provided as a promise!");
      });
      it("should throw when instantiating a sync binding with an async dependency",
          () {
        var injector = Injector.resolveAndCreate(
            [bind(UserList).toAsyncFactory(fetchUsers), UserController]);
        expect(() => injector.get(UserController)).toThrowError(
            "Cannot instantiate UserList synchronously. It is provided as a promise! (UserController -> UserList)");
      });
      it("should not throw when instantiating a sync binding with a resolved async dependency",
          inject([AsyncTestCompleter], (async) {
        var injector = Injector.resolveAndCreate(
            [bind(UserList).toAsyncFactory(fetchUsers), UserController]);
        injector.asyncGet(UserList).then((_) {
          expect(() {
            injector.get(UserController);
          }).not.toThrow();
          async.done();
        });
      }));
      it("should resolve synchronously when an async dependency requested as a promise",
          () {
        var injector = Injector.resolveAndCreate(
            [bind(UserList).toAsyncFactory(fetchUsers), AsyncUserController]);
        var controller = injector.get(AsyncUserController);
        expect(controller).toBeAnInstanceOf(AsyncUserController);
        expect(controller.userList).toBePromise();
      });
      it("should wrap sync dependencies into promises if required", () {
        var injector = Injector.resolveAndCreate([
          bind(UserList).toFactory(() => new UserList()),
          AsyncUserController
        ]);
        var controller = injector.get(AsyncUserController);
        expect(controller).toBeAnInstanceOf(AsyncUserController);
        expect(controller.userList).toBePromise();
      });
    });
  });
}
