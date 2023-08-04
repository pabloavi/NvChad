;;extends
;;item
("\\item" @punctuation.special @conceal (#set! conceal "○"))

((generic_command command: (command_name) @function @conceal 
(#any-of? @function "\\textit" "\\textbf" "\\SI" "\\num")) 
(#set! conceal ""))

((generic_command command: (command_name) @conceal 
(#eq? @function "\\micro")) 
(#set! conceal "µ"))
