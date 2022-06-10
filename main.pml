 /* Generated from ../reo-compiler/sandbox/switch/main2.treo by Reo 1.0.*/

#define N 3 		// output ports
#define NB_ROWS 10	// table size
#define STAR 888888888
#define BLOCK 9999999 			// Define the blocking value 
#define M 3 		//memory in queue


#include "runtime.pml"


/* port declarations */
port p1; port q1; port q2; port p2; // port q0 ; port c0; portTriple p00; portFlow p01; 


//#define que_emp ((len(que) == 0 ))
//#define que_nemp ((len(que) != 0 ))

/* ltl properties */
/* sending and receiving with specific ports */
ltl prop1 { [] ((m1.header==11) -> <> (msg1.header==11))} //true
ltl prop2 { []((m2.header==22) -> (<> (msg2.header==22) && <> (msg1.header ==22)))} //true
/* unexpected packets */
ltl prop3 { <>(msg1.header==11)&&(<>[](msgacounter==1))} //F
ltl prop4 {[](!(msgacounter==2))} //T


/* switch protocol */
proctype Protocol1(port np1; port np2 ; port nq1;  port nq2 ){
	/* Initialization of table, checking prop1 and prop2 */
	/*
	t[1].guard.ipt=STAR;
	t[1].guard.header=STAR;
	t[1].out[0]=0;
	t[1].out[1]=BLOCK;
	t[1].out[2]=BLOCK;

	t[0].guard.ipt=2;
	t[0].guard.header=STAR;
	t[0].out[0]=BLOCK;
	t[0].out[1]=1;
	t[0].out[2]=2;
	*/
	/* Initialization of table, checking prop3 */
	t[0].guard.ipt=STAR;
	t[0].guard.header=STAR;
	t[0].out[0]=0;
	t[0].out[1]=BLOCK;
	t[0].out[2]=BLOCK;
	
	int sem;
	message _np;
	message _nq0, _nq1, _nq2, _nc0;
	triple _np00;
	flowmod _np01;
	pif E; 
	triple A; 
	int STATE=1;
	bool Fp11; bool Fp12; bool Fp112; bool Fp1; bool Fp10; bool Fp101; bool Fp102; bool Fp1012;
	Fp11=1; Fp12=1; Fp112=1; Fp1=1; Fp10=1; Fp101=1; Fp102=1; Fp1012=1;
	bool  Fc1; bool Fc2; bool Fc12; bool Fc0;
 	Fc1=1; Fc2=1; Fc12=1; Fc0=1;
	bool Fp21; bool Fp22; bool Fp212; bool Fp2; bool Fp20; bool Fp201; bool Fp202; bool Fp2012;
	Fp21=1; Fp22=1; Fp212=1; Fp2=1; Fp20=1; Fp201=1; Fp202=1; Fp2012=1;
	do
	//-------------------------------------------------------------
	//p1->q1
	:: full(np1.data) && full(nq1.trig) && Fp11==1 -> atomic{ Ped(np1, sem); if
		:: sem==1 -> take(np1, _np); AddIpt(1, _np, A); Matching(A, E); Func1( E , _nq1); put(nq1, _nq1); Fp11=1; Fp12=1; Fp112=1; Fp1=1; Fp10=1; Fp101=1; Fp102=1; Fp1012=1;
		:: else -> Fp11=0; 
		fi;}
	//p1->q2
	:: full(np1.data) && full(nq2.trig) && Fp12==1 -> atomic{Ped(np1, sem); if
		:: sem==2 -> take(np1, _np); AddIpt(1, _np, A); Matching(A, E); Func1( E , _nq2); put(nq2, _nq2); Fp11=1; Fp12=1; Fp112=1; Fp1=1; Fp10=1; Fp101=1; Fp102=1; Fp1012=1;
		:: else -> Fp12=0; 
		fi;}
	
	//p1?
	:: full(np1.data) && Fp1==1 -> atomic{Ped(np1, sem); if
		:: sem==7 -> take(np1, _np); Fp11=1; Fp12=1; Fp112=1; Fp1=1; Fp10=1; Fp101=1; Fp102=1; Fp1012=1;
		:: else -> Fp1=0;
		fi;}
		
	//p1->q0 
	:: full(np1.data) && nfull(que) && Fp10==1 -> atomic{Ped(np1, sem); if
		:: sem==0 -> atomic{take(np1, _np); AddIpt(1, _np, A); Matching(A, E); Func1( E , _nq0);  que ! _nq0; Fp11=1; Fp12=1; Fp112=1; Fp1=1; Fp10=1; Fp101=1; Fp102=1; Fp1012=1;}
		:: else -> Fp10=0; 
		fi;}
	//p1->q0,q1
	:: full(np1.data) && nfull(que) && full(nq1.trig) && Fp101==1 -> atomic{Ped(np1, sem); if
		:: sem==3 -> take(np1, _np); AddIpt(1, _np, A); Matching(A, E); Func2( E , _nq0, _nq1); put(nq1, _nq1); STATE=1; que ! _nq0;  Fp11=1; Fp12=1; Fp112=1; Fp1=1; Fp10=1; Fp101=1; Fp102=1; Fp1012=1;
		:: else -> Fp101=0; 
		fi;}
	//p1->q0,q2
	:: full(np1.data) && nfull(que) && full(nq2.trig) && Fp102==1 -> atomic{Ped(np1, sem); if
		:: sem==5 -> take(np1, _np); AddIpt(1, _np, A); Matching(A, E); Func2( E , _nq0, _nq2); put(nq2, _nq2); que ! _nq0; STATE=1; Fp11=1; Fp12=1; Fp112=1; Fp1=1; Fp10=1; Fp101=1; Fp102=1; Fp1012=1;
		:: else -> Fp102=0; 
		fi;}
	//p1->q1,q2
	:: full(np1.data) && full(nq1.trig) && full(nq2.trig) && Fp112==1 -> atomic{Ped(np1, sem); if
		:: sem==4 -> take(np1, _np); AddIpt(1, _np, A); Matching(A, E); Func2( E , _nq1, _nq2); put(nq1, _nq1); put(nq2, _nq2); Fp11=1; Fp12=1; Fp112=1; Fp1=1; Fp10=1; Fp101=1; Fp102=1; Fp1012=1;
		:: else -> Fp112=0; 
		fi;}
	//p1->q0,q1,q2
	:: full(np1.data) && nfull(que) && full(nq1.trig) && full(nq2.trig) && Fp1012==1 -> atomic{Ped(np1, sem); if
		:: sem==6 -> take(np1, _np); AddIpt(1, _np, A); Matching(A, E); Func3( E , _nq0, _nq1, _nq2); put(nq1, _nq1); put(nq2, _nq2); que ! _nq0; STATE=1; Fp11=1; Fp12=1; Fp112=1; Fp1=1; Fp10=1; Fp101=1; Fp102=1; Fp1012=1;
		:: else -> Fp1012=0;
		fi;}
	
	//c->update;q1  -----------nempty(que) to be removed--------------!!!
	:: nempty(que) && full(nq1.trig) && Fc1==1 -> atomic{Pred(que, sem); if
		:: sem==1 -> atomic{que ? _nc0; Controller(_nc0, _np00, _np01); Update(_np01); Rmv(_np00, E);  Func1(E, _nq1); put(nq1, _nq1); Fc1=1; Fc2=1; Fc12=1; Fc0=1;}
		:: else -> Fc1=0;
		fi;}
	//c->update;q2
	:: nempty(que) && full(nq2.trig) && Fc2==1 -> atomic{Pred(que, sem); if
		:: sem==2 -> que ? _nc0; Controller(_nc0, _np00, _np01); Update(_np01); Rmv(_np00, E);  Func1(E, _nq2); put(nq2, _nq2); Fc1=1; Fc2=1; Fc12=1; Fc0=1;
		:: else -> Fc2=0;
		fi;}
	//c->update;q1,q2
	:: nempty(que) && full(nq1.trig) && full(nq2.trig) && Fc12==1 -> atomic{Pred(que, sem); if
		:: sem==4 -> que ? _nc0; Controller(_nc0, _np00, _np01); Update(_np01); Rmv(_np00, E);  Func2(E, _nq1, _nq2); put(nq1, _nq1); put(nq2, _nq2); Fc1=1; Fc2=1; Fc12=1; Fc0=1;
		:: else -> Fc12=0;
		fi;}
	//c->update; drop
	:: nempty(que) && Fc0==1 -> atomic{Pred(que, sem); if
		:: sem==7 -> que ? _nc0; Controller(_nc0, _np00, _np01); Update(_np01); Fc1=1; Fc2=1; Fc12=1; Fc0=1;
		:: else -> Fc0=0;
		fi;}
		
	//------------------------------------------------------------------
	//p2->q1
	:: full(np2.data) && full(nq1.trig) && Fp21==1 -> atomic{Ped2(np2, sem); if
		:: sem==1 -> take(np2, _np); AddIpt(2, _np, A); Matching(A, E); Func1( E , _nq1); put(nq1, _nq1); Fp21=1; Fp22=1; Fp212=1; Fp2=1; Fp20=1; Fp201=1; Fp202=1; Fp2012=1;
		:: else -> Fp21=0; 
		fi;}
	//p2->q2
	:: full(np2.data) && full(nq2.trig) && Fp22==1 -> atomic{Ped2(np2, sem); if
		:: sem==2 -> take(np2, _np); AddIpt(2, _np, A); Matching(A, E); Func1( E , _nq2); put(nq2, _nq2); Fp21=1; Fp22=1; Fp212=1; Fp2=1; Fp20=1; Fp201=1; Fp202=1; Fp2012=1;
		:: else -> Fp22=0; 
		fi;}
	
	//p2?
	:: full(np2.data) && Fp2==1 -> atomic{Ped2(np2, sem); if
		:: sem==7 -> take(np2, _np); Fp21=1; Fp22=1; Fp212=1; Fp2=1; Fp20=1; Fp201=1; Fp202=1; Fp2012=1;
		:: else -> Fp2=0;
		fi;}
	//p2->q0 
	:: full(np2.data) && nfull(que) && Fp20==1 -> atomic{Ped2(np2, sem); if
		:: sem==0 -> take(np2, _np); AddIpt(2, _np, A); Matching(A, E); Func1( E , _nq0);  que ! _nq0; Fp21=1; Fp22=1; Fp212=1; Fp2=1; Fp20=1; Fp201=1; Fp202=1; Fp2012=1;
		:: else -> Fp20=0; 
		fi;}
	//p2->q0,q1
	:: full(np2.data) && nfull(que) && full(nq1.trig) && Fp201==1 -> atomic{Ped2(np2, sem); if
		:: sem==3 -> take(np2, _np); AddIpt(2, _np, A); Matching(A, E); Func2( E , _nq0, _nq1); put(nq1, _nq1); STATE=1; que ! _nq0; Fp21=1; Fp22=1; Fp212=1; Fp2=1; Fp20=1; Fp201=1; Fp202=1; Fp2012=1;
		:: else -> Fp201=0; 
		fi;}
	//p2->q0,q2
	:: full(np2.data) && nfull(que) && full(nq2.trig) && Fp202==1 -> atomic{Ped2(np2, sem); if
		:: sem==5 -> take(np2, _np); AddIpt(2, _np, A); Matching(A, E); Func2( E , _nq0, _nq2); put(nq2, _nq2); que ! _nq0; STATE=1; Fp21=1; Fp22=1; Fp212=1; Fp2=1; Fp20=1; Fp201=1; Fp202=1; Fp2012=1;
		:: else -> Fp202=0; 
		fi;}
		
	//p2->q1,q2
	:: full(np2.data) && full(nq1.trig) && full(nq2.trig) && Fp212==1 -> atomic{Ped2(np2, sem); if
		:: sem==4 -> take(np2, _np); AddIpt(2, _np, A); Matching(A, E); Func2( E , _nq1, _nq2); put(nq1, _nq1); put(nq2, _nq2); Fp21=1; Fp22=1; Fp212=1; Fp2=1; Fp20=1; Fp201=1; Fp202=1; Fp2012=1;
		:: else -> Fp212=0; 
		fi;}
		
	//p2->q0,q1,q2
	:: full(np2.data) && nfull(que) && full(nq1.trig) && full(nq2.trig) && Fp2012==1 -> atomic{Ped2(np2, sem); if
		:: sem==6 -> take(np2, _np); AddIpt(2, _np, A); Matching(A, E); Func3( E , _nq0, _nq1, _nq2); put(nq1, _nq1); put(nq2, _nq2); que ! _nq0; Fp21=1; Fp22=1; Fp212=1; Fp2=1; Fp20=1; Fp201=1; Fp202=1; Fp2012=1;
		:: else -> Fp2012=0;
		fi;}
		
	od
}



init {
			//switch 1, p00-triple-pktout, p01-flowmod, 
		atomic{
		run prod1(p1)	; // to controller -> update table -> Q1
		run prod2(p2)	; // to Q1 & Q2
		run Protocol1(p1, p2, q1, q2)	;	
		run cons1(q1)	;
		run cons2(q2);
		}
}

