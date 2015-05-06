library angular2.src.di.annotations_impl;

import "package:angular2/src/facade/lang.dart"
    show
        CONST; /**
 * A parameter annotation that specifies a dependency.
 *
 * ```
 * class AComponent {
 *   constructor(@Inject(MyService) aService:MyService) {}
 * }
 * ```
 *
 * @exportedAs angular2/di_annotations
 */

class Inject {
  final token;
  @CONST() const Inject(token) : token = token;
} /**
 * A parameter annotation that specifies a `Promise` of a dependency.
 *
 * ```
 * class AComponent {
 *   constructor(@InjectPromise(MyService) aServicePromise:Promise<MyService>) {
 *     aServicePromise.then(aService:MyService => ...);
 *   }
 * }
 * ```
 *
 * @exportedAs angular2/di_annotations
 */
class InjectPromise {
  final token;
  @CONST() const InjectPromise(token) : token = token;
} /**
 * A parameter annotation that creates a synchronous lazy dependency.
 *
 * ```
 * class AComponent {
 *   constructor(@InjectLazy(MyService) aServiceFn:Function) {
 *     var aService:MyService = aServiceFn();
 *   }
 * }
 * ```
 *
 * @exportedAs angular2/di_annotations
 */
class InjectLazy {
  final token;
  @CONST() const InjectLazy(token) : token = token;
} /**
 * A parameter annotation that marks a dependency as optional. {@link Injector} provides `null` if the dependency is not
 * found.
 *
 * ```
 * class AComponent {
 *   constructor(@Optional() aService:MyService) {
 *     this.aService = aService;
 *   }
 * }
 * ```
 *
 * @exportedAs angular2/di_annotations
 */
class Optional {
  @CONST() const Optional();
} /**
 * `DependencyAnnotation` is used by the framework to extend DI.
 *
 * Only annotations implementing `DependencyAnnotation` are added to the list of dependency properties.
 *
 * For example:
 *
 * ```
 * class Parent extends DependencyAnnotation {}
 * class NotDependencyProperty {}
 *
 * class AComponent {
 *   constructor(@Parent @NotDependencyProperty aService:AService) {}
 * }
 * ```
 *
 * will create the following dependency:
 *
 * ```
 * new Dependency(Key.get(AService), [new Parent()])
 * ```
 *
 * The framework can use `new Parent()` to handle the `aService` dependency
 * in a specific way.
 *
 * @exportedAs angular2/di_annotations
 */
class DependencyAnnotation {
  @CONST() const DependencyAnnotation();
  get token {
    return null;
  }
} /**
 * A marker annotation that marks a class as available to `Injector` for creation. Used by tooling for
 * generating constructor stubs.
 *
 * ```
 * class NeedsService {
 *   constructor(svc:UsefulService) {}
 * }
 *
 * @Injectable
 * class UsefulService {}
 * ```
 * @exportedAs angular2/di_annotations
 */
class Injectable {
  @CONST() const Injectable();
}
