library angular2.test.core.compiler.query_list_spec;

import "package:angular2/test_lib.dart"
    show describe, it, expect, beforeEach, ddescribe, iit, xit, el;
import "package:angular2/src/facade/collection.dart"
    show List, MapWrapper, ListWrapper, iterateListLike;
import "package:angular2/src/core/compiler/query_list.dart" show QueryList;

main() {
  describe("QueryList", () {
    var queryList, log;
    beforeEach(() {
      queryList = new QueryList();
      log = "";
    });
    logAppend(item) {
      log += (log.length == 0 ? "" : ", ") + item;
    }
    it("should support adding objects and iterating over them", () {
      queryList.add("one");
      queryList.add("two");
      iterateListLike(queryList, logAppend);
      expect(log).toEqual("one, two");
    });
    it("should support resetting and iterating over the new objects", () {
      queryList.add("one");
      queryList.add("two");
      queryList.reset(["one again"]);
      queryList.add("two again");
      iterateListLike(queryList, logAppend);
      expect(log).toEqual("one again, two again");
    });
    describe("simple observable interface", () {
      it("should fire callbacks on change", () {
        var fires = 0;
        queryList.onChange(() {
          fires += 1;
        });
        queryList.fireCallbacks();
        expect(fires).toEqual(0);
        queryList.add("one");
        queryList.fireCallbacks();
        expect(fires).toEqual(1);
        queryList.fireCallbacks();
        expect(fires).toEqual(1);
      });
      it("should support removing callbacks", () {
        var fires = 0;
        var callback = () => fires += 1;
        queryList.onChange(callback);
        queryList.add("one");
        queryList.fireCallbacks();
        expect(fires).toEqual(1);
        queryList.removeCallback(callback);
        queryList.add("two");
        queryList.fireCallbacks();
        expect(fires).toEqual(1);
      });
    });
  });
}
