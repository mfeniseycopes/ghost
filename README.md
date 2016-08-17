# Ghost
Console version of the classic road-trip game, [Ghost][wiki].
[wiki]: https://en.wikipedia.org/wiki/Ghost_(game)

Ghost is a two player console game.

## Playing the Game

1. Clone the repo.
2. From the console,within the repo directory, run `ruby ghost.rb`.
3. Players take turns adding a letter to the word, trying to not complete a word.

## About the Game

Ghost is a single file game that takes in a file "dictionary.txt" to supply it with available words.

### Working Dictionary

Each successive play reduces the working dictionary to only words that begin with those characters played. So after the kth turn, each word in the working dictionary is checked against it's kth letter. If it matches it is kepts, otherwise it is removed. This utilizes slightly more memory, but is substantially faster than checking against the entire dictionary after every turn.
