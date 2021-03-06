# Enhance the XML program to add spaces to show the indentation structure.
# Enhance the XML program to handle attributes: if the first argu- ment is a map (use the curly brackets syntax), add attributes to the XML program. For example:
# book({"author": "Tate"}...) would print <book author="Tate">:

Builder := Object clone
Builder indent := 0

# when an unknown message is sent to builder, parse it as an XML tag
Builder forward := method(
    self indent repeat(write("    "))

    # handle XML attributes
    if (call message arguments at(0) name != "curlyBrackets",
        writeln("<", call message name, ">"),
        write("<", call message name)
        call message arguments at(0) arguments foreach(arg,
            attr := arg asString split(" : ") at(0) removePrefix("\"") removeSuffix("\"")
            write(" ", attr, "=", arg asString split(" : ") at(1))
        )
        writeln(">")
    )

    # store the current indentation level
    closing_indent := self indent

    call message arguments foreach(i, arg,
        if (i == 0,
            self indent = self indent + 1,
            self indent = closing_indent + 1
        )
        if (arg name != "curlyBrackets",
            content := self doMessage(arg);
            if (content type == "Sequence",
                self indent repeat(write("    "))
                writeln(content)
            )
        )
    )

    closing_indent repeat(write("    "))
    writeln("</", call message name, ">")
)

b1 := Builder clone
b1 body(
    ul(
        {
            "id" : "test",
            "class" : "blue",
            "title" : "mylist"
        },
        li("item 1 - ",
            a(
                {"href" : "google.com"},
                "link 1"
            )
        ),
        li("item 2 - ",
            a("link 2")
        ),
        li("item 3 - ",
            a("link 3")
        )
    ),
    p("A test paragraph to go with your list")
)
writeln

# Create a list syntax that uses brackets.
Object squareBrackets := method(call message arguments)
List squareBrackets := method(
    self at(call message arguments at(0) asString asNumber)
)
people := ["kate", "tom", "james"]
writeln("the people are: ", people)
writeln("the second person is: ", people[1])
writeln("there's no person 10: ", people[9])
