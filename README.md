# textToCode
An iOS app that turns your speech into valid java code. 

- [ ] TODO: multi word class names, method names, and variable names (eg: getFood)
- [ ] TODO: support static
- [ ] TODO: parameters for methods add a "parameters" key word
- [ ] TODO: variable assignments
- [ ] TODO: Switch method/class scope
- [ ] TODO: return statements
- [ ] TODO: probably a lot more stuff

Order: 
1. Outline of code: New classes, class variables, new methods 
2. Actual Code: "Enter class", "Enter method", write code now, "exit method", "exit class"

Example working input: 
>New private class dog new private variable string head new public method kick returns Boolean new private variable string leg

Gets the output: 
```java
private class dog(){
    private string head;
    public boolean kick(){
        private string leg;
    }
}
```