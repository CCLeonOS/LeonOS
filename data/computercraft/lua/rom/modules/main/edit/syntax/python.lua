local syn = {
  whitespace = {
    {
      function(c)
        return c:match("[ \n\r\t]")
      end,
      function()
        return false
      end,
      function(c)
        return c:match("^[ \n\r\t]+")
      end
    },
  },
  word = {
    {
      function(c)
        return not not c:match("[a-zA-Z_]")
      end,
      function(_, c)
        return not not c:match("[a-zA-Z_0-9]")
      end
    }
  },
  keyword = {
    "and", "as", "assert", "break", "class", "continue", "def",
    "del", "elif", "else", "except", "finally", "for", "from",
    "global", "if", "import", "in", "is", "lambda", "nonlocal",
    "not", "or", "pass", "raise", "return", "try", "while",
    "with", "yield"
  },
  builtin = {
    "abs", "all", "any", "ascii", "bin", "bool", "breakpoint", "bytearray",
    "bytes", "callable", "chr", "classmethod", "compile", "complex", "delattr",
    "dict", "dir", "divmod", "enumerate", "eval", "exec", "filter", "float",
    "format", "frozenset", "getattr", "globals", "hasattr", "hash", "help",
    "hex", "id", "input", "int", "isinstance", "issubclass", "iter", "len",
    "list", "locals", "map", "max", "memoryview", "min", "next", "object",
    "oct", "open", "ord", "pow", "print", "property", "range", "repr",
    "reversed", "round", "set", "setattr", "slice", "sorted", "staticmethod",
    "str", "sum", "super", "tuple", "type", "vars", "zip", "__import__"
  },
  separator = {
    ",", "(", ")", "{", "}", "[", "]", ":", ";",
  },
  operator = {
    "+", "-", "/", "*", "**", "//", "==", "=", ">", "<", ">=", "<=",
    "!=", "&", "|", "^", "%", "~", ">>", "<<", "+=", "-=", "*=", "/=",
    "%=", "**=", "//=", "&=", "|=", "^=", ">>=", "<<="
  },
  boolean = {
    "True", "False", "None"
  },
  comment = {
    {
      function(c)
        return c == "#"
      end,
      function(t,c)
        return c ~= "\n"
      end,
      function(t)
        return #t > 0
      end
    }
  },
  string = {
    {
      function(c)
        return c == "'" or c == '"'
      end,
      function(t, c)
        local first = t:sub(1,1)
        local last = t:sub(#t)
        local penultimate = t:sub(-2, -2)
        if #t == 1 then return true end
        if first == last and penultimate ~= "\\" then return false end
        return true
      end
    },
    {
      function(c)
        return c == '"' and (t == '"' or t == '')
      end,
      function(t,c)
        if t:match("^"""$) and c == '"' then
          return false
        end
        if t:match("^"""[^"]*$) then
          return true
        end
        return false
      end,
      function(t)
        return t:match("^"""[^"]*"""$)
      end
    },
    {
      function(c)
        return c == "'" and (t == "'" or t == '')
      end,
      function(t,c)
        if t:match("^'''$") and c == "'" then
          return false
        end
        if t:match("^'''[^']*$") then
          return true
        end
        return false
      end,
      function(t)
        return t:match("^'''[^']*'''$)
      end
    }
  },
  number = {
    {
      function(c)
        return not not tonumber(c)
      end,
      function(t, c)
        return not not tonumber(t .. c .. "0") or (c == '.' and not t:find('\.'))
      end
    }
  }
}

return syn