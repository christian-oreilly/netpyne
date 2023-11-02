TITLE Mod file for component: Component(id=poissonFiringSyn type=poissonFiringSynapse)

COMMENT

    This NEURON file has been generated by org.neuroml.export (see https://github.com/NeuroML/org.neuroml.export)
         org.neuroml.export  v1.10.0
         org.neuroml.model   v1.10.0
         jLEMS               v0.11.0

ENDCOMMENT

NEURON {
    POINT_PROCESS poissonFiringSyn
    ELECTRODE_CURRENT i
    RANGE weight                            : property
    RANGE averageRate                       : parameter
    RANGE averageIsi                        : parameter
    RANGE SMALL_TIME                        : parameter
    RANGE i                                 : exposure
    RANGE syn0_tauRise                      : parameter
    RANGE syn0_tauDecay                     : parameter
    RANGE syn0_peakTime                     : parameter
    RANGE syn0_waveformFactor               : parameter
    RANGE syn0_gbase                        : parameter
    RANGE syn0_erev                         : parameter
    RANGE syn0_g                            : exposure
    RANGE syn0_i                            : exposure
    RANGE iSyn                              : derived variable
    : Based on netstim.mod
    THREADSAFE : only true if every instance has its own distinct Random
    POINTER donotuse
}

UNITS {
    
    (nA) = (nanoamp)
    (uA) = (microamp)
    (mA) = (milliamp)
    (A) = (amp)
    (mV) = (millivolt)
    (mS) = (millisiemens)
    (uS) = (microsiemens)
    (nF) = (nanofarad)
    (molar) = (1/liter)
    (kHz) = (kilohertz)
    (mM) = (millimolar)
    (um) = (micrometer)
    (umol) = (micromole)
    (pC) = (picocoulomb)
    (S) = (siemens)
    
}

PARAMETER {
    
    weight = 1
    averageRate = 0.05 (kHz)               : was: 50.0 (per_time)
    averageIsi = 20 (ms)                   : was: 0.02 (time)
    SMALL_TIME = 1.0E-9 (ms)               : was: 1.0000000000000002E-12 (time)
    syn0_tauRise = 0.5 (ms)                : was: 5.0E-4 (time)
    syn0_tauDecay = 10 (ms)                : was: 0.01 (time)
    syn0_peakTime = 1.5767012 (ms)         : was: 0.0015767011966073639 (time)
    syn0_waveformFactor = 1.2324           : was: 1.232399909181873 (none)
    syn0_gbase = 0.002 (uS)                : was: 2.0E-9 (conductance)
    syn0_erev = 0 (mV)                     : was: 0.0 (voltage)
}

ASSIGNED {
    v (mV)
    isi (ms)                      : Not a state variable as far as Neuron's concerned...
    syn0_g (uS)                             : derived variable
    syn0_i (nA)                             : derived variable
    iSyn (nA)                               : derived variable
    i (nA)                                  : derived variable
    rate_tsince (ms/ms)
    rate_tnextUsed (ms/ms)
    rate_tnextIdeal (ms/ms)
    rate_syn0_A (/ms)
    rate_syn0_B (/ms)
    donotuse
}

STATE {
    tsince (ms) : dimension: time
    tnextIdeal (ms) : dimension: time
    tnextUsed (ms) : dimension: time
    syn0_A  : dimension: none
    syn0_B  : dimension: none
    
}

INITIAL {
    rates()
    rates() ? To ensure correct initialisation.
    
    tsince = 0
    
    isi = -  averageIsi  * log(random_float(1))
    
    tnextIdeal = isi
    
    tnextUsed = isi
    
    net_send(0, 1) : go to NET_RECEIVE block, flag 1, for initial state
    
    syn0_A = 0
    
    syn0_B = 0
    
}

BREAKPOINT {
    
    SOLVE states METHOD cnexp
    
    
}

NET_RECEIVE(flag) {
    
    LOCAL weight
    
    
    if (flag == 1) { : Setting watch for top level OnCondition...
        WATCH (t >  tnextUsed) 1000
    }
    if (flag == 1000) {
    
        tsince = 0
    
        isi = -  averageIsi  * log(1 - random_float(1))
    
        tnextIdeal = (  tnextIdeal  +  isi  )
    
        tnextUsed = tnextIdeal  *H( (  tnextIdeal  -t)/t ) + (t+  SMALL_TIME  )*H( (t-  tnextIdeal  )/t )
    
        : Child: Component(id=syn0 type=expTwoSynapse)
    
        : This child is a synapse; defining weight
        weight = 1
    
        : paramMappings are: {poissonFiringSyn={tsince=tsince, tnextIdeal=tnextIdeal, tnextUsed=tnextUsed, isi=isi, weight=weight, averageRate=averageRate, averageIsi=averageIsi, SMALL_TIME=SMALL_TIME, i=i, iSyn=iSyn}, syn0={A=syn0_A, B=syn0_B, tauRise=syn0_tauRise, tauDecay=syn0_tauDecay, peakTime=syn0_peakTime, waveformFactor=syn0_waveformFactor, gbase=syn0_gbase, ...
        : state_discontinuity(syn0_A, syn0_A  + (weight *  syn0_waveformFactor ))
        syn0_A = syn0_A  + (weight *  syn0_waveformFactor )
    
        : paramMappings are: {poissonFiringSyn={tsince=tsince, tnextIdeal=tnextIdeal, tnextUsed=tnextUsed, isi=isi, weight=weight, averageRate=averageRate, averageIsi=averageIsi, SMALL_TIME=SMALL_TIME, i=i, iSyn=iSyn}, syn0={A=syn0_A, B=syn0_B, tauRise=syn0_tauRise, tauDecay=syn0_tauDecay, peakTime=syn0_peakTime, waveformFactor=syn0_waveformFactor, gbase=syn0_gbase, ...
        : state_discontinuity(syn0_B, syn0_B  + (weight *  syn0_waveformFactor ))
        syn0_B = syn0_B  + (weight *  syn0_waveformFactor )
    
        net_event(t)
        WATCH (t >  tnextUsed) 1000
    
    }
    
}

DERIVATIVE states {
    rates()
    tsince' = rate_tsince 
    tnextUsed' = rate_tnextUsed 
    tnextIdeal' = rate_tnextIdeal 
    syn0_A' = rate_syn0_A 
    syn0_B' = rate_syn0_B 
    
}

PROCEDURE rates() {
    
    syn0_g = syn0_gbase  * ( syn0_B  -  syn0_A ) ? evaluable
    syn0_i = syn0_g  * ( syn0_erev  - v) ? evaluable
    ? DerivedVariable is based on path: synapse/i, on: Component(id=poissonFiringSyn type=poissonFiringSynapse), from synapse; Component(id=syn0 type=expTwoSynapse)
    iSyn = syn0_i ? path based, prefix = 
    
    i = weight  *  iSyn ? evaluable
    rate_tsince = 1 ? Note units of all quantities used here need to be consistent!
    rate_tnextUsed = 0 ? Note units of all quantities used here need to be consistent!
    rate_tnextIdeal = 0 ? Note units of all quantities used here need to be consistent!
    
     
    rate_syn0_A = - syn0_A  /  syn0_tauRise ? Note units of all quantities used here need to be consistent!
    rate_syn0_B = - syn0_B  /  syn0_tauDecay ? Note units of all quantities used here need to be consistent!
    
     
    
}


: Returns a float between 0 and max; implementation of random() as used in LEMS
FUNCTION random_float(max) {
    
    : This is not ideal, getting an exponential dist random number and then turning back to uniform
    : However this is the easiest what to ensure mod files with random methods fit into NEURON's
    : internal framework for managing internal number generation.
    random_float = exp(-1*erand())*max
    
}

:****************************************************
: Methods copied from netstim.mod in NEURON source

 
PROCEDURE seed(x) {
	set_seed(x)
}

VERBATIM
double nrn_random_pick(void* r);
void* nrn_random_arg(int argpos);
ENDVERBATIM


FUNCTION erand() {
VERBATIM
	if (_p_donotuse) {
		/*
		:Supports separate independent but reproducible streams for
		: each instance. However, the corresponding hoc Random
		: distribution MUST be set to Random.negexp(1)
		*/
		_lerand = nrn_random_pick(_p_donotuse);
	}else{
		/* only can be used in main thread */
		if (_nt != nrn_threads) {
           hoc_execerror("multithread random in NetStim"," only via hoc Random");
		}
ENDVERBATIM
		: the old standby. Cannot use if reproducible parallel sim
		: independent of nhost or which host this instance is on
		: is desired, since each instance on this cpu draws from
		: the same stream
		erand = exprand(1)
VERBATIM
	}
ENDVERBATIM
}

PROCEDURE noiseFromRandom() {
VERBATIM
 {
	void** pv = (void**)(&_p_donotuse);
	if (ifarg(1)) {
		*pv = nrn_random_arg(1);
	}else{
		*pv = (void*)0;
	}
 }
ENDVERBATIM
}

: End of methods copied from netstim.mod in NEURON source
:****************************************************


: The Heaviside step function
FUNCTION H(x) {
    
    if (x < 0) { H = 0 }
    else if (x > 0) { H = 1 }
    else { H = 0.5 }
    
}

