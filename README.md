# go_router_example

路由跳转有两种方法:go, push

区别:

- go: 如果新路由不是旧路由的子路由,则移除当前路由栈
- push: 将新路由推送到当前栈顶

for example:
路由: A[B,C], 从B跳转到C  
跳转前的路由栈: A-B   
跳转后:

- go: A-C ,
- push: A-B-C

所以,定义路由线路的时候,一定要确定好路由的层级;跳转路由的时候,想好是使用go还是push.
