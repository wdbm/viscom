# viscom

visual communications

# viscom-t

```Bash
viscom-t.sh text.txt
```

```Bash
viscom-t.sh test.png
```

# converting to ASCII binary

A file, for example `log.pdf`, can be converted to binary in the following way:

```Bash
filein="log_raw.pdf"
fileout="log_binary_ascii.txt"

data="$((echo obase=2; hexdump -ve'/1 "%u\n"' "${filein}") | bc | xargs printf %08i)"
inputText="$(echo "${inputText}" | sed 's/\(.*\)/\L\1/')"
echo "${data}" > "${fileout}"
```

The script `viscom-t.sh` uses this method and then flashes the terminal corresponding to the ASCII binary representation.

# converting from ASCII binary

A file, for example `log_binary_ascii.txt`, consisting of ASCII binary, can be converted from binary ASCII in the following way:

```Bash
filein="log_binary_ascii.txt"
fileout="log.pdf"

cat "${filein}" | perl -pe 's/([01]{8})/sprintf "%c", oct("0b$1")/ge' > "${fileout}"
```
