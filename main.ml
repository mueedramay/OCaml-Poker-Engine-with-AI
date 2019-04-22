open Card
open Hand_evaluator
open Montecarlo

let rec read_integer prompt_str ?(condition=(fun x -> true)) () =
  let retry () =
    print_newline ();
    print_string "Invalid amount.";
    read_integer prompt_str ~condition () in
  State.prompt prompt_str;

  let input = read_line () in
  if input = "quit" then exit 0
  else
    let num = try int_of_string input with
      | Failure _ ->
        retry () in
    if condition num then num else retry ()

let print_hline () =
  for i = 1 to 100 do
    print_char '-'
  done;
  print_newline ();
  print_newline ()

let print_intro () =
  print_endline "Tips:";
  print_string "    The player whose turn it is is shown in ";
  ANSITerminal.(print_string [green] "green");
  print_endline ".";
  print_string "    The button is shown in ";
  ANSITerminal.(print_string [red] "red");
  print_endline ".";
  print_newline ();
  ANSITerminal.(print_string [yellow] "LET'S PLAY!");
  print_newline ();
  print_newline ();
  print_newline ()

let print_list func = function
  | h :: t ->
    func h;
    List.iter (fun x -> print_string ", "; func x) t;
    print_newline ()
  | _ -> print_endline "none"

let print_string_list = print_list print_string
let print_int_list = print_list print_int

let print_players_in st =
  let lst = State.players_in st in
  ANSITerminal.(
    List.iter
      (fun x ->
         print_string
           (
             if x = (State.player_turn st) then [green]
             else if x = (State.button st) then [red]
             else [default]
           )
           ((State.find_participant st x).name ^ " ($" ^
            (string_of_int (State.find_stack x st.table.participants)) ^
            ")    ");
      ) lst;
    print_newline ()
  )

let print_player_bets st =
  let lst = State.bet_paid_amt st in
  let rec helper = function
    | [] -> ()
    | (a,b) :: t -> if b != 0 then
        (
          let p = State.find_participant st a in
          print_string p.name;
          print_string " added $";
          print_int b;
          print_endline " to the pot.";
          helper t
        ) in
  let sorted = List.sort compare lst in
  helper sorted;
  print_newline ()

let print_current_state st =
  ANSITerminal.(
    print_string [yellow] (Player.name (State.find_participant st (State.player_turn st)));
    print_string [yellow] "'s turn"
  );
  print_newline ();
  print_newline ();
  print_endline "Cards on the board: ";
  (Card.card_printer (Table.board (State.table st)));
  print_newline ();
  print_players_in st;
  print_newline ();
  print_player_bets st;
  print_newline ();
  print_string "Available actions: ";
  print_string_list ("quit" :: (State.avail_action st))





let play_game st =
  print_intro ();

  let rec keep_playing st =
    let winning_id = State.winning_player st in
    if (fst winning_id) >= 0 then
      let string = "The winner is player " ^ string_of_int (fst winning_id)
                   ^ " with " ^ Hand_evaluator.rank_mapper (snd winning_id) ^ "!" in
      ANSITerminal.(print_string [yellow] string);
      print_newline ();
      print_newline ();
      keep_playing (State.continue_game st)
    else
      print_hline ();
    print_current_state st;
    State.prompt "";

    (* Easy Bot *)
    if (State.game_type st) = 1 && State.player_turn st = 2 then
      if List.mem "check" (State.avail_action st) then
        match State.check st with
        | Legal t ->
          print_newline ();
          print_endline (Command.command_to_string Check);
          print_newline ();
          keep_playing (State.get_avail_action t)
        | Illegal str->
          print_newline ();
          print_endline str;
          print_newline ();
          keep_playing (State.get_avail_action st)
      else if List.mem "call" (State.avail_action st) then
        match (State.call st) with
        | Legal t ->
          print_newline ();
          print_endline (Command.command_to_string Call);
          print_newline ();
          keep_playing (State.get_avail_action t)
        | Illegal str->
          print_newline ();
          print_endline str;
          print_newline ();
          keep_playing (State.get_avail_action st)
      else failwith "AI next move not defined"

    (* Medium Bot *)
    else if (State.game_type st) = 2 && State.player_turn st = 2 then
      let next_action = Montecarlo.declare_action (State.find_participant st 2)
          (Player.cards (State.find_participant st 2)) st 50000 in
      let action = fst next_action in
      print_endline action;
      let amt = snd next_action in
      print_int amt;
      print_newline();
      if action = "raise" then
        match Command.parse (action ^ " " ^ string_of_int amt) with
        | comm ->
          (match State.command_to_function comm st with
           | Legal t ->
             print_newline ();
             print_endline (Command.command_to_string comm);
             print_newline ();
             keep_playing (State.get_avail_action t);
           | Illegal s -> failwith s)
      else
        match Command.parse action with
        | comm ->
          (match State.command_to_function comm st with
           | Legal t ->
             print_newline ();
             print_endline (Command.command_to_string comm);
             print_newline ();
             keep_playing (State.get_avail_action t);
           | Illegal s -> failwith s)
    else

      match read_line () with
      | curr_cmd ->
        match Command.parse curr_cmd with
        | exception Command.Malformed ->
          print_newline ();
          print_endline "Not a valid command.";
          keep_playing st

        | exception Command.Empty ->
          print_newline ();
          print_endline "Please enter a command.";
          keep_playing st

        | Quit -> exit 0

        | comm ->
          let func = State.command_to_function comm in
          match func st with
          | Legal t ->
            print_newline ();
            print_endline (Command.command_to_string comm);
            print_newline ();
            keep_playing (State.get_avail_action t)
          | Illegal str->
            print_newline ();
            print_endline str;
            print_newline ();
            keep_playing (State.get_avail_action st)
  in
  keep_playing st

(** [init_game num_players] initializes a game with [num_players] players.
    Requires: integer amount of players [num_players].
    Example: [init_game 3] initializes a game with 3 players. *)
let init_game num_players =
  let money = read_integer "Starting stack amount?"
      ~condition:(fun x -> x >= 10 && x <= 5000) () in
  let blind = read_integer "Blind amount?"
      ~condition:(fun x -> x >= 2 && x <= money / 10) () in
  let st = match num_players with
    | 1 -> State.prompt "Difficulty of AI? (easy, medium, hard)";
      (
        let game_type = match read_line () with
          | "easy" -> 1
          | "medium" -> 2
          | "hard" -> 3
          | _ -> failwith "ERROR: not a valid difficulty" in
        State.init_state game_type 2 money blind
      )
    | x when x > 0 -> State.init_state 0 x money blind
    | _ -> failwith "ERROR: negative number of players" in
  print_newline ();
  print_newline ();
  play_game st

(** [main ()] prompts the user for the number of players,
    then starts the game. *)
let main () =
  print_newline ();
  print_newline ();
  ANSITerminal.(print_string [blue] "Welcome to OCaml Poker.");
  print_newline ();

  read_integer "How many (human) players are there?"
    ~condition:(fun x -> x > 0 && x <= 10) ()

  |> init_game


(* Execute the game engine. *)
let () = main ()