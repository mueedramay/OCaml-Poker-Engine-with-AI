open Deck
type ascii_card = Deck.card * string

let rank_symbols = ["A";"2";"3";"4";"5";"6";"7";"8";"9";"10";"J";"Q";"K"]
let suits_symbols = ["♠";"♦";"♥";"♣"]

let card_to_ascii (suit,rank) =
  failwith "unimplemented"
