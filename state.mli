open Yojson

(** [bet] is the bet situation of the current round:
    [bet_player] : the player that has bet / raised the last
    [bet_amount] : the current bet amount that the next player has to match
    [bet_paid_amt] : the current bet situation
    in form (player, bet_amount) list
*)
type bet = {
  bet_player: int;
  bet_amount: int;
  bet_paid_amt: (int*int) list;
}

(** [t] is the state of the game described using the following information:
    [game_type] : an integer representin a game type
      0 if it is a multiplayer game, 1 if it is against the AI
    [num_players] : the number of players in the game
    [table] : type Table.table that represents the table
    [player_turn] : the player that has the action
    [button] : the person that goes last in the hand
    [players_in] : the list of players that are currently playing the hand
    [bet] : current bet situation in this round
    [avail_action] : the available actions that the current player can act
    [winner] : is a tuple of (player_id, rank) where player_id is the player
    with the winning hand and the rank is the rank of the hand evaluated by
    hand evaluator.
*)
type t = {
  game_type: int;
  num_players: int;
  table: Table.table;
  player_turn: int;
  button : int;
  players_in: int list;
  players_played: int list;
  bet: bet;
  avail_action: string list;
  winner: (int*int);
}

val read_integer : string -> ?condition:(int -> bool) * string -> unit -> int

val read_string : string -> ?condition:(string -> bool) * string -> unit -> string

(** [prompt str] prompts the user for input, using the string [str].
    Requires: [str] is a valid string.
    Example: [prompt "Please enter some text."] prints to the screen:

    Please enter some text.
    >
*)
val prompt : string -> unit

(** [game_type st] is the type of the game being played in [st].
    Requires: valid state [st].
    Example: [game_type st] is 0 if [st] is a multiplayer game. *)
val game_type : t -> int

(** [num_players st] is the number of players in the game being played in [st].
    Requires: valid state [st].
    Example: [num_players st] is 3 if [st] has 3 players. *)
val num_players : t -> int

(** [table st] is the information about the table
    in the game being played in [st].
    Requires: valid state [st].
    Example: [table st] is
    [{
    pot = 500;
    blind = 5;
    participants = [1; 2; 3];
    board = [(Hearts, Three); (Diamonds, Four)];
    }]
    in a game with a three total players and a blind of $5,
    two cards currently on the board, and $500 in the pot.
*)
val table : t -> Table.table

(** [player_turn st] is the type of the game being played in [st].
    Requires: valid state [st].
    Example: [player_turn st] is 3 after the first two moves of the game. *)
val player_turn : t -> int

(** [players_in st] is the list of players who are playing
    in the current round
    of the game being played in [st].
    Requires: valid state [st].
    Example: [players_in st] is [[1; 4]] if the game started
    with four players and players 2 and 3 folded. *)
val players_in : t -> int list

(** [button st] is the player who is the button
    in the game being played in [st].
    Requires: valid state [st].
    Example: [button st] is 3 in the first hand of a game
    with three players. *)
val button : t -> int

(** [continue_game st] is [st] with no winner set.
    Requires: valid state [st].
    Example: [continue_game st] is a state with winner set to -1
    instead of the previous winner. *)
val continue_game : t -> t

(** [winning_player st] is the player that has won the hand in state [st].
    Requires: valid state [st]. *)
val winning_player : t -> (int*int)

(** [bet st] is the amount currently being bet
    in the game being played in [st].
    Requires: valid state [st].
    Example: [bet st] is $10 after the big blind goes
    if the blind is set to 10. *)
val bet : t -> bet

(** [avail_action st] is the list of available actions
    in the game being played in [st].
    Requires: valid state [st].
    Example: [avail_action st] is [[fold]] if the only possible action left
    for the player is folding. *)
val avail_action : t -> string list

(** [init_state st] is the initial state
    of the game being played in [st].
    Requires: valid state [st].
    Example: [init_state st] is a state with three players in
    if the game has three players. *)
val init_state : int -> int -> int -> int -> t

(** [init_bet lst] is the initial bet for an initial list [lst] of players
    REquires: [lst] must be a list of integers ranging from 1 to n
    number of players*)
val init_bet : int list -> bet

(** [hand_order num_players button] is an integer list
    containing integers from (button + 1) to num_players and then from 1
    to button.
    Requires: [button >= 1] and [num_players >= 1]
    Requires: [button <= num_players]
    Example:  [hand_order 5 3] is [[4; 5; 1; 2; 3]] *)
val hand_order : int -> int -> int list

(** [bet_paid_amt st] is the list of tuples of players
    and how much money they have paid in state [st].
    Requires: valid state [st].
    Example: [bet_paid_amt st] is [[(1,2); (2,5)]] in a two-player game
    after both blinds go. *)
val bet_paid_amt : t -> (int * int) list

(** [move_result] is the type representing the result
    of a player executing a command. *)
type move_result =
  | Legal of t
  | Illegal of string

(** [check st] is the result of the player calling the check command.
    Requires: valid state [st].
    Example: [check st] is [st] with it being the next player's turn. *)
val check : t -> move_result

(** [call st] is the result of the player calling the call command.
    Requires: valid state [st].
    Example: [call st] is [st] with the player's bet raised
    to the current bet amount. *)
val call : t -> move_result

(** [fold st] is the result of the player calling the fold command.
    Requires: valid state [st].
    Example: [fold st] is [st] with the current player removed
    from the hand. *)
val fold : t -> move_result

(*(** [stack st] is the result of the player calling the stack command.
    Requires: valid state [st].
    Example: [stack st] is [st] with three 500s printed to the console
    if there are three players in the hand with $500 each. *)
  val stack : t -> move_result*)

(** [command_to_function comm] is the function in State
    associated with the command [comm].
    Requires: valid command [comm].
    Example: [command_to_function Check] is [State.check]. *)
val command_to_function : Command.command -> (t -> move_result)

(** [winner st] is the player that wins the round and the rank of
    the winning hand, in the form (player, rank).
    Requires: state has a nonempty list of players.
    Requires: there are 5 hole cards.
    Throws "cannot determine winner" exception if called on
    list of empty players or hole cards less than 5.
    Example: [winner st] is [(1,28)] if player 1 wins with a hand
    of value 28. *)
val winner : t -> (Player.player*int)

(** [get_avail_action st] is the list of valid commands
    the player can currently execute.
    Requires: valid state [st]. *)
val get_avail_action : t -> t

(** [calculate_pay_amt] st returns the amount that the current player has
    to put into the pot to call either a bet or a raise *)
val calculate_pay_amt : t -> int

(** [find_participant] st target returns a type Player.player of a player that
    has an id of target. *)
val find_participant : t -> int -> Player.player

(** [find_stack id st] is the amount of money that the player
    with id [id] has in state [st].
    Requires: valid state [st], valid player id [id].
    Example: [find_stack 2 st] is the amount of money that the big blind has
    in the given state [st]. *)
val find_stack : int -> Player.player list -> int

(** [bet_or_raise] amt st comm_str returns a state where the player has
    bet or raised, according to the string comm_str and returns the next state
    Requires: st is a vaild state
              the player has at least amt in his stack
              comm_str is either "bet" or "raise"
*)
val bet_or_raise : int -> t -> string -> move_result

(** [pay_blinds st] is the state [st] with players having payed blinds
    Requires: st is a valid state*)
val pay_blinds : t -> t

val load : Basic.json -> t

val save : string -> t -> t