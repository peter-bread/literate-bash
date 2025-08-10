# Example

First we do the shebang:

```bash
#!/usr/bin/env bash
```

Now we say hello:

```bash
echo "Hello"
```

Write a function:

```bash
say() {
  if [[ -n $1 ]]; then
    echo "[SAY] $1"
  else
    echo "[ERR] well give me something to say then..."
  fi
}
```

Then we can use the function:

```bash
say
say "hey"
say "you are weird"
```
