# msgForward
oc 消息转发机制

消息转发分为三大阶段

第一阶段先征询消息接收者所属的类，看其是否能动态添加方法，以处理当前这个无法响应的 selector，这叫做 动态方法解析（dynamic method resolution）。
如果运行期系统（runtime system） 
第一阶段执行结束，接收者就无法再以动态新增方法的手段来响应消息，进入第二阶段。

第二阶段看看有没有其他对象（备援接收者，replacement receiver）能处理此消息。
如果有，运行期系统会把消息转发给那个对象，转发过程结束；如果没有，则启动完整的消息转发机制。

第三阶段 完整的消息转发机制。运行期系统会把与消息有关的全部细节都封装到 NSInvocation 对象中，
再给接收者最后一次机会，令其设法解决当前还未处理的消息。


动态方法解析

/**
 *  如果尚未实现的方法是实例方法，则调用此函数
 *
 *  @param selector 未处理的方法
 *
 *  @return 返回布尔值，表示是否能新增实例方法用以处理selector
 */
+ (BOOL)resolveInstanceMethod:(SEL)selector;
/**
 *  如果尚未实现的方法是类方法，则调用此函数
 *
 *  @param selector 未处理的方法
 *
 *  @return 返回布尔值，表示是否能新增类方法用以处理selector
 */
+ (BOOL)resolveClassMethod:(SEL)selector;



备援接收者

如果无法 动态解析方法，运行期系统就会询问是否能将消息转给其他接收者来处理，对应的方法为

/**
 *  此方法询问是否能将消息转给其他接收者来处理
 *
 *  @param aSelector 未处理的方法
 *
 *  @return 如果当前接收者能找到备援对象，就将其返回；否则返回nil；
 */
- (id)forwardingTargetForSelector:(SEL)aSelector;
在对象内部，可能还有其他对象，该对象可通过此方法将能够处理 selector 的相关内部对象返回，在外界看来，就好像是该对象自己处理的似得。



完整的消息转发机制

如果前面两步都无法处理消息，就会启动完整的消息转发机制。首先创建 NSInvocation 对象，
把尚未处理的那条消息有关的全部细节装在里面，在触发 NSInvocation 对象时，
消息派发系统（message-dispatch system）将会把消息指派给目标对象。对应的方法为

/**
 *  消息派发系统通过此方法，将消息派发给目标对象
 *
 *  @param anInvocation 之前创建的NSInvocation实例对象，用于装载有关消息的所有内容
 */
- (void)forwardInvocation:(NSInvocation *)anInvocation;
这个方法可以实现的很简单，通过改变调用的目标对象，使得消息在新目标对象上得以调用即可。然而这样实现的效果与 备援接收者 差不多，所以很少人会这么做。
更加有用的实现方式为：在触发消息前，先以某种方式改变消息内容，比如追加另一个参数、修改 selector 等等。

总结

消息转发的全部流程可以用这张图概括




