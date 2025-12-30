Red [title: "Conf"]


; DSL parsing rules
character: charset [#"1" - #"9" #"a" - #"z" #"A" - #"Z" #" " #"=" #"[" #"]"]
comment: [#";" any [character]]

lowercase-letter: charset[#"a" - #"z"]
nonzero-digit: charset [#"1" - #"9"]
digit: charset [#"0" - #"9"]
symbol: [some lowercase-letter opt [#"0" | [nonzero-digit any [digit]]]]

key: [symbol]
value: [any [character]]
pair: [key any [#" "] #"=" any [#" "] value]

header: [#"[" any [#" "] symbol any [#" "] #"]"]

dsl: [
    [any [#" "] comment]
    |
    [any [#" "] pair any [#" "] opt comment]
    |
    [any [#" "] header any [#" "] opt comment]
]


; Parse and execute DSL input
parse-dsl: func [input [string!]][
    lines: split trim input #"^/"
    result: "OK"
    foreach line lines [if not line == "" [
        if not parse line dsl [
                print line
                result: "NOK"
            ]]
        ]
    print result
]

args: system/script/args
either args == "" [
    print "USAGE: conf <file.conf>"
][
    conf: read to file! args
    parse-dsl conf
]
