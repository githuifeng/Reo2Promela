typedef message {
	int header; // Meta data
	int ipt; // Input port reference 
}

typedef port {
	chan data = [1] of {message};
	chan trig = [1] of {bit}; 
}

typedef condition {
	int ipt	 ; // condition for ipt
	int header	// condition for header
}
// FLowmod message from controler
typedef flowmod {
	int tag;	 	// is xy where x=1, y in {1,2,3,...} (example 11 is function add,12 is function remove, 13 is function modify)
	condition guard; 		// matching condition
	int out[N];		// output ports
}

typedef portFlow {
	chan data = [1] of {flowmod};
	chan trig = [1] of {bit}; 
}
typedef triple {
	int tag	   ;  // If 0, ipt in [1,n], else  1
	message m ; 	// This is the message
	int out[N]	   ;  // output ports to forward the message
}
typedef portTriple {
	chan data = [1] of {triple};
	chan trig = [1] of {bit}; 
}



typedef pif {
	message m ; 	// This is the message
	int out[N]	   ;  // output ports to forward the message
}



// Type for table, flowmod without tag
typedef table {
	condition guard;
	int out[N]
}

typedef pair {
	triple tri;
	table t;
}

typedef pairf {
	flowmod f;
	table t;
}
inline take(a,b){
	a.trig!1 ; a.data?b
} 

inline put(a,b){
	bit x;
	a.data!b ; a.trig?x; 
} 

/* Definition of table, queue, global messages  */
table t[NB_ROWS];
chan que = [M] of {message};
message m1;
message m2;
message msg1;
message msg2;
int msgacounter;	

proctype prod1(port a){
	//message m; 
	
	bit x;
	m1.header = 1; m1.ipt = 0; atomic{ a.data!m1; m1.header = 0; a.trig?x; }
	
}

proctype prod2(port a){
	//message m;
	
	bit x;
	m2.header = 1; m2.ipt = 0 ; atomic{ a.data!m2; m2.header = 0; a.trig?x; }
}

proctype cons1(port a){
	msgacounter=0;
	do
	:: atomic{take(a,msg1); msgacounter++;} //msg1.ipt=msg.ipt;
	od
	
}

proctype cons2(port a){
	do
	:: take(a,msg2); //msg2.ipt=msg.ipt;
	od
}
/* Input for AddIpt
   a:int is the input port reference
   b:message is the input port message
 
   Behavior
   takes the message from b.
   set the ipt field the value a.
  
   Output 
   c:triple
*/
inline AddIpt(a, b, c){
	c.tag = 0 ;
	c.m.header = b.header ;
	c.m.ipt = a;
}



/* Input for Matching
   a:pair(triple,table) (input message)
   a:triple
   Output for Matching
  b:pif  (triple without tag) 
*/
	
inline Matching(a,b){
	int k = 0; // table lines
	int i = 0; // t.[out] rows
	do //initialize the t[k].out[i] -> t[all]out[all]=BLOCK
		:: (i<N) && (b.out[i] == BLOCK) -> i++
		:: else -> break
	od;
	do //match, k from 0 to max.
		:: (t[k].out[1] == 0) -> break
		:: else ->  if 
		       		:: ((t[k].guard.ipt == a.m.ipt) || (t[k].guard.ipt == STAR)) && ((t[k].guard.header == a.m.header) || (t[k].guard.header == STAR) ) -> b.m.ipt = a.m.ipt ; b.m.header = a.m.header ; int j = 0 -> 
			              do 
					:: j<N -> b.out[j] = t[k].out[j] ; j++ 	// j is the sequence number of output ports.
					:: else -> break;
			              od; break
		       		:: else -> k++
			     fi
	od
} 

/* Cut function
input
  e:pif
output
  m:message
behavior:
removes every field from e except its message
*/
inline Cut(e,output){
	output.ipt = e.m.ipt; 
	output.header = e.m.header;
}

inline Func1(e, output){
	output.ipt = e.m.ipt; 
	output.header = e.m.header;
}
inline Func2(e, output1, output2){
	output1.ipt = e.m.ipt; 
	output1.header = e.m.header;
	output2.ipt = e.m.ipt; 
	output2.header = e.m.header;
}
inline Func3(e, output1, output2, output3){
	output1.ipt = e.m.ipt; 
	output1.header = e.m.header;
	output2.ipt = e.m.ipt; 
	output2.header = e.m.header;
	output3.ipt = e.m.ipt; 
	output3.header = e.m.header;
}
/* Update
input:
  h:flowmod
behavior
  update the table with the flowmod message
*/

inline Update(h){

if
  :: h.tag == 11 -> add(h)
 // :: _h.tag == 12 -> remove()
 // :: _h.tag == 13 -> modify()
fi;
}

inline add(h) {
//table row;
int size = 0 ;
do 
	:: t[size].out[1] == 0 -> break;
	:: t[size].out[1] != 0 -> size++;
od; 
int k = size;
int i =0;
int w;// [0..out[N]]
do
  :: k >0 -> t[k].guard.ipt = t[k-1].guard.ipt ; t[k].guard.header = t[k-1].guard.header ; for (w : 0 .. N-1) {
			t[k].out[w] = t[k-1].out[w];
		}; k--;//t[k]=t[k-1], until k=0;
	/*	do 
			:: i<N -> h.t[k].out[i] = h.t[k-1].out[i] ; i++
			:: else -> break
		od; k--
	*/
  :: else -> i=0; t[0].guard.ipt = h.guard.ipt ; t[0].guard.header = h.guard.header ; 
		do 
			:: i<N -> t[0].out[i] = h.out[i] ; i++
			:: else -> break //i=N
		od; break;
od
}



/* Rmv function
input
  e:triple
output
  p:pif
behavior:
removes
*/
inline Rmv(e,p){
	p.m.ipt = e.m.ipt; 
	p.m.header = e.m.header;
	int i = 0;
	do 
		:: i<N -> p.out[i] = e.out[i] ; i++
		:: else -> break
	od
}


/* pair/merger function
input
 a:triple
 b:table[N]
output
 c:[triple, table[N]]
behavior:
 an array of data Trible and data Table[N]
*/
inline Pair(a,b,c){
	
	c.tri.tag = a.tag;
	c.tri.m = a.m;
	c.t.guard = b.guard;
	int i = 0;
	do 
		:: i<N -> c.tri.out[i] = a.out[i] ; c.t.out[i] = b.out[i]; i++
		:: else -> break
	od
}
/* input
a: message, to be stored in que;
output
b: message, to take the first element of que;
*/
inline Queue(a, b){
	do
		:: nempty(que) -> atomic {que ? b; }; // que write
		:: nfull(que) -> atomic {que ! a}; //que read
	od
}
/*input 
w: message; 
output
tr:triple; to be put in the port p00
f:flowmod; to be put in the port p01
*/
/* controller for prop1 and prop2*/
/*
inline Controller(w, tr, f){
	
	if	
	  :: w.ipt==1 -> atomic{//send triple message
			tr.tag = 0;
			tr.m.header = w.header;
			tr.m.ipt = w.ipt ;
			tr.out[0] = BLOCK ;
			tr.out[1] = 1 ; 
			tr.out[2] = BLOCK;
			//put(np00,tr); 
			f.tag = 11;//insert flowmod rule
			f.guard.header = w.header;
			f.guard.ipt = STAR ;
			f.out[0] = BLOCK ;
			f.out[1] = 1 ; 
			f.out[2] = BLOCK;}
			//put(np01,f); 
	 :: w.ipt==2 -> atomic{ tr.tag = 0; 
			tr.m.header = w.header;
			tr.m.ipt = w.ipt ;
			tr.out[0] = BLOCK ;
			tr.out[1] = 1 ; 
			tr.out[2] = 2;
			f.tag = 11;//insert flowmod rule
			f.guard.header = w.header;
			f.guard.ipt = STAR ;
			f.out[0] = BLOCK ;
			f.out[1] = 1 ; 
			f.out[2] = 2;}
	fi
}
*/
/*controller for checking prop3*/
inline Controller(w, tr, f){
	
	if	
	  :: (w.ipt==1) -> atomic{//send triple message
			tr.tag = 0;
			tr.m.header = w.header;
			tr.m.ipt = w.ipt ;
			tr.out[0] = BLOCK ;
			tr.out[1] = 1 ; 
			tr.out[2] = BLOCK;
			//put(np00,tr); 
			f.tag = 11;//insert flowmod rule
			f.guard.header = w.header;
			f.guard.ipt = STAR;
			f.out[0] = BLOCK ;
			f.out[1] = 1 ; 
			f.out[2] = BLOCK;}
			//put(np01,f); 
	 :: (w.ipt==2) -> atomic{ tr.tag = 0; 
			tr.m.header = w.header;
			tr.m.ipt = w.ipt ;
			tr.out[0] = BLOCK ;
			tr.out[1] = BLOCK ; 
			tr.out[2] = BLOCK;
			f.tag = 11;//insert flowmod rule
			f.guard.header = w.header;
			f.guard.ipt = STAR ;
			f.out[0] = BLOCK ;
			f.out[1] = BLOCK ; 
			f.out[2] = BLOCK;}
	fi
}
/*
---Predicate for the transitions from controller to switch--------
input: 
e: message; channel [que] with message; 
output: 
flag: int;
*/
inline Pred(qu, flag){
	message e;
	qu?<e>;
	triple _e1; pif u;
	flowmod c;
	Controller(e, _e1, c);
	Rmv(_e1, u);
	
	if
		:: u.out[0] == 0 && u.out[1] == BLOCK && u.out[2] == BLOCK -> flag=0;
		:: u.out[0] == BLOCK && u.out[1] == 1 && u.out[2] == BLOCK -> flag=1;
		:: u.out[0] == BLOCK && u.out[1] == BLOCK && u.out[2] == 2-> flag=2;
		:: u.out[0] == 0 && u.out[1] == 1 && u.out[2] == BLOCK -> flag=3;
		:: u.out[0] == BLOCK && u.out[1] == 1 && u.out[2] == 2 -> flag=4;
		:: u.out[0] == 0 && u.out[1] == BLOCK && u.out[2] == 2 -> flag=5;
		:: u.out[0] == 0 && u.out[1] == 1 && u.out[2] == 2 -> flag=6;
		:: else -> flag=7;
	fi
}


/*
------predicate for the transitions from Pi to Qj--------
input: 
b: port with message;
output:
u: pif; flag: int;
*/
inline Ped(b, flag1){
	message me1;
	b.data?<me1>;
	triple _me1; pif u1;
	AddIpt(1, me1, _me1); Matching(_me1, u1);
	if
		:: u1.out[0] == 0 && u1.out[1] == BLOCK && u1.out[2] == BLOCK -> flag1=0;
		:: u1.out[0] == BLOCK && u1.out[1] == 1 && u1.out[2] == BLOCK -> flag1=1;
		:: u1.out[0] == BLOCK && u1.out[1] == BLOCK && u1.out[2] == 2 -> flag1=2;
		:: u1.out[0] == 0 && u1.out[1] == 1 && u1.out[2] == BLOCK -> flag1=3;
		:: u1.out[0] == BLOCK && u1.out[1] == 1 && u1.out[2] == 2 -> flag1=4;
		:: u1.out[0] == 0 && u1.out[1] == BLOCK && u1.out[2] == 2 -> flag1=5;
		:: u1.out[0] == 0 && u1.out[1] == 1 && u1.out[2] == 2 -> flag1=6;
		:: else -> flag1=7;
	fi
}

inline Ped2(b, flag2){
	message me2;
	b.data?<me2>;
	triple _me2; pif u2;
	AddIpt(2, me2, _me2); Matching(_me2, u2);
	if
		:: u2.out[0] == 0 && u2.out[1] == BLOCK && u2.out[2] == BLOCK -> flag2=0;
		:: u2.out[0] == BLOCK && u2.out[1] == 1 && u2.out[2] == BLOCK -> flag2=1;
		:: u2.out[0] == BLOCK && u2.out[1] == BLOCK && u2.out[2] == 2 -> flag2=2;
		:: u2.out[0] == 0 && u2.out[1] == 1 && u2.out[2] == BLOCK -> flag2=3;
		:: u2.out[0] == BLOCK && u2.out[1] == 1 && u2.out[2] == 2 -> flag2=4;
		:: u2.out[0] == 0 && u2.out[1] == BLOCK && u2.out[2] == 2 -> flag2=5;
		:: u2.out[0] == 0 && u2.out[1] == 1 && u2.out[2] == 2 -> flag2=6;
		:: else -> flag2=7;
	fi
}
/*
proctype consFinite(port a){
	bit y;
	int i = 5;
	do
		:: i>0; atomic{take(a,y)}; i = i-1
		:: break
	od
}
*/

