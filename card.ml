open Deck

(* The following 4 lists are actually string representations of cards
   in the different suits. They are used for printing purposes and appear
   like this in order to meet the 80 character limit restriction. *)
(*BISECT-IGNORE-BEGIN*)
let diamonds = [
  "┌─────────┐";"┌─────────┐";"┌─────────┐";"┌─────────┐";"┌─────────┐";
  "┌─────────┐";"┌─────────┐";"┌─────────┐";"┌─────────┐";"┌─────────┐";
  "┌─────────┐";"┌─────────┐";"┌─────────┐";
  "│2        │";"│3        │";"│4        │";"│5        │";"│6        │";
  "│7        │";"│8        │";"│9        │";"│10       │";"│J        │";
  "│Q        │";"│K        │";"│A        │";
  "│         │";"│         │";"│         │";"│         │";"│         │";
  "│         │";"│         │";"│         │";"│         │";"│         │";
  "│         │";"│         │";"│         │";
  "│         │";"│         │";"│         │";"│         │";"│         │";
  "│         │";"│         │";"│         │";"│         │";"│         │";
  "│         │";"│         │";"│         │";
  "│    ♦    │";"│    ♦    │";"│    ♦    │";"│    ♦    │";"│    ♦    │";
  "│    ♦    │";"│    ♦    │";"│    ♦    │";"│    ♦    │";"│    ♦    │";
  "│    ♦    │";"│    ♦    │";"│    ♦    │";
  "│         │";"│         │";"│         │";"│         │";"│         │";
  "│         │";"│         │";"│         │";"│         │";"│         │";
  "│         │";"│         │";"│         │";
  "│         │";"│         │";"│         │";"│         │";"│         │";
  "│         │";"│         │";"│         │";"│         │";"│         │";
  "│         │";"│         │";"│         │";
  "│        2│";"│        3│";"│        4│";"│        5│";"│        6│";
  "│        7│";"│        8│";"│        9│";"│       10│";"│        J│";
  "│        Q│";"│        K│";"│        A│";
  "└─────────┘";"└─────────┘";"└─────────┘";"└─────────┘";"└─────────┘";
  "└─────────┘";"└─────────┘";"└─────────┘";"└─────────┘";"└─────────┘";
  "└─────────┘";"└─────────┘";"└─────────┘";
]
let clubs = [
  "┌─────────┐";"┌─────────┐";"┌─────────┐";"┌─────────┐";"┌─────────┐";
  "┌─────────┐";"┌─────────┐";"┌─────────┐";"┌─────────┐";"┌─────────┐";
  "┌─────────┐";"┌─────────┐";"┌─────────┐";
  "│2        │";"│3        │";"│4        │";"│5        │";"│6        │";
  "│7        │";"│8        │";"│9        │";"│10       │";"│J        │";
  "│Q        │";"│K        │";"│A        │";
  "│         │";"│         │";"│         │";"│         │";"│         │";
  "│         │";"│         │";"│         │";"│         │";"│         │";
  "│         │";"│         │";"│         │";
  "│         │";"│         │";"│         │";"│         │";"│         │";
  "│         │";"│         │";"│         │";"│         │";"│         │";
  "│         │";"│         │";"│         │";
  "│    ♣    │";"│    ♣    │";"│    ♣    │";"│    ♣    │";"│    ♣    │";
  "│    ♣    │";"│    ♣    │";"│    ♣    │";"│    ♣    │";"│    ♣    │";
  "│    ♣    │";"│    ♣    │";"│    ♣    │";
  "│         │";"│         │";"│         │";"│         │";"│         │";
  "│         │";"│         │";"│         │";"│         │";"│         │";
  "│         │";"│         │";"│         │";
  "│         │";"│         │";"│         │";"│         │";"│         │";
  "│         │";"│         │";"│         │";"│         │";"│         │";
  "│         │";"│         │";"│         │";
  "│        2│";"│        3│";"│        4│";"│        5│";"│        6│";
  "│        7│";"│        8│";"│        9│";"│       10│";"│        J│";
  "│        Q│";"│        K│";"│        A│";
  "└─────────┘";"└─────────┘";"└─────────┘";"└─────────┘";"└─────────┘";
  "└─────────┘";"└─────────┘";"└─────────┘";"└─────────┘";"└─────────┘";
  "└─────────┘";"└─────────┘";"└─────────┘";
]
let spades = [
  "┌─────────┐";"┌─────────┐";"┌─────────┐";"┌─────────┐";"┌─────────┐";
  "┌─────────┐";"┌─────────┐";"┌─────────┐";"┌─────────┐";"┌─────────┐";
  "┌─────────┐";"┌─────────┐";"┌─────────┐";
  "│2        │";"│3        │";"│4        │";"│5        │";"│6        │";
  "│7        │";"│8        │";"│9        │";"│10       │";"│J        │";
  "│Q        │";"│K        │";"│A        │";
  "│         │";"│         │";"│         │";"│         │";"│         │";
  "│         │";"│         │";"│         │";"│         │";"│         │";
  "│         │";"│         │";"│         │";
  "│         │";"│         │";"│         │";"│         │";"│         │";
  "│         │";"│         │";"│         │";"│         │";"│         │";
  "│         │";"│         │";"│         │";
  "│    ♠    │";"│    ♠    │";"│    ♠    │";"│    ♠    │";"│    ♠    │";
  "│    ♠    │";"|   ♠     │";"│    ♠    │";"│    ♠    │";"│    ♠    │";
  "|    ♠    │";"│    ♠    │";"│    ♠    │";
  "│         │";"│         │";"│         │";"│         │";"│         │";
  "│         │";"│         │";"│         │";"│         │";"│         │";
  "│         │";"│         │";"│         │";
  "│         │";"│         │";"│         │";"│         │";"│         │";
  "│         │";"│         │";"│         │";"│         │";"│         │";
  "│         │";"│         │";"│         │";
  "│        2│";"│        3│";"│        4│";"│        5│";"│        6│";
  "│        7│";"│        8│";"│        9│";"│       10│";"│        J│";
  "│        Q│";"│        K│";"│        A│";
  "└─────────┘";"└─────────┘";"└─────────┘";"└─────────┘";"└─────────┘";
  "└─────────┘";"└─────────┘";"└─────────┘";"└─────────┘";"└─────────┘";
  "└─────────┘";"└─────────┘";"└─────────┘";
]
let hearts = [
  "┌─────────┐";"┌─────────┐";"┌─────────┐";"┌─────────┐";"┌─────────┐";
  "┌─────────┐";"┌─────────┐";"┌─────────┐";"┌─────────┐";"┌─────────┐";
  "┌─────────┐";"┌─────────┐";"┌─────────┐";
  "│2        │";"│3        │";"│4        │";"│5        │";"│6        │";
  "│7        │";"│8        │";"│9        │";"│10       │";"│J        │";
  "│Q        │";"│K        │";"│A        │";
  "│         │";"│         │";"│         │";"│         │";"│         │";
  "│         │";"│         │";"│         │";"│         │";"│         │";
  "│         │";"│         │";"│         │";
  "│         │";"│         │";"│         │";"│         │";"│         │";
  "│         │";"│         │";"│         │";"│         │";"│         │";
  "│         │";"│         │";"│         │";
  "│    ♥    │";"│    ♥    │";"│    ♥    │";"│    ♥    │";"│    ♥    │";
  "│    ♥    │";"│    ♥    │";"│    ♥    │";"│    ♥    │";"│    ♥    │";
  "│    ♥    │";"│    ♥    │";"│    ♥    │";
  "│         │";"│         │";"│         │";"│         │";"│         │";
  "│         │";"│         │";"│         │";"│         │";"│         │";
  "│         │";"│         │";"│         │";
  "│         │";"│         │";"│         │";"│         │";"│         │";
  "│         │";"│         │";"│         │";"│         │";"│         │";
  "│         │";"│         │";"│         │";
  "│        2│";"│        3│";"│        4│";"│        5│";"│        6│";
  "│        7│";"│        8│";"│        9│";"│       10│";"│        J│";
  "│        Q│";"│        K│";"│        A│";
  "└─────────┘";"└─────────┘";"└─────────┘";"└─────────┘";"└─────────┘";
  "└─────────┘";"└─────────┘";"└─────────┘";"└─────────┘";"└─────────┘";
  "└─────────┘";"└─────────┘";"└─────────┘";
]
(*BISECT-IGNORE-END*)
let card_printer cardlist =
  let rec card_builder count start_index target_list outlist =
    if count = 9 then List.rev outlist
    else let element = List.nth target_list start_index in
      card_builder (count + 1) (start_index + 13) (target_list) 
        (element :: outlist) in
  let rank_to_int rank = match rank with
    | Two -> 0
    | Three -> 1
    | Four -> 2
    | Five -> 3
    | Six -> 4
    | Seven -> 5
    | Eight -> 6
    | Nine -> 7
    | Ten -> 8
    | Jack -> 9
    | Queen -> 10
    | King -> 11
    | Ace -> 12 in
  let element card = match card with
    | (Diamonds, rank) -> (card_builder 0 (rank_to_int rank) (diamonds) [],
                           Diamonds)
    | (Hearts, rank) -> (card_builder 0 (rank_to_int rank) (hearts) [], Hearts)
    | (Spades, rank) -> (card_builder 0 (rank_to_int rank) (spades) [], Spades)
    | (Clubs, rank) -> (card_builder 0 (rank_to_int rank) (clubs) [], Clubs) in
  let str_list_list = List.map element cardlist in
  let white_printer line = ANSITerminal.(print_string [black] (line)) in
  let red_printer line = ANSITerminal.(print_string [red] (line)) in
  let rec all_lines count card_list original_list = match card_list with
    | [] when count = 8 -> ()
    | [] -> print_newline (); all_lines (count + 1) original_list original_list
    | (h, Diamonds) :: t -> red_printer (List.nth h count);
      print_string "    ";
      all_lines count t original_list
    | (h, Hearts) :: t -> red_printer (List.nth h count);
      print_string "    ";
      all_lines count t original_list
    | (h, Clubs) :: t -> white_printer (List.nth h count);
      print_string "    ";
      all_lines count t original_list
    | (h, Spades) :: t -> white_printer (List.nth h count);
      print_string "    ";
      all_lines count t original_list in
  all_lines 0 str_list_list str_list_list