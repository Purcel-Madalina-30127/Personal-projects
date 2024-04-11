%% PARTEA I
clc

n=1.23;
% amplificatorul de putere

Kap = 20+0.25*n
Tap = 10^-2
HAP = tf(Kap,1,'IoDelay',Tap)
% motorul de antrenare

K1 = 0.25+(10^-2)*n
K2 = 5+0.1*n
TM1 = 0.05+2*(10^-3)*n
TM2 = 0.5+(10^-2)*n
HM1 = tf(K1,[TM1 1])
HM2 = tf(K2,[TM2 1])

% tahogeneratorul de masurare a turatiei

KTo = 0.1
TTo = 10^-2
HTo = tf(KTo,[TTo,1])

% transportorul melcat

TQ1=5
TTM=5
KTM=0.12+(10^-2)*n
TB=60
HTM1=tf(0.05,conv(TB,[TQ1 1]))
HTM2=tf(KTM,[TTM 1])

% transportorul cu cupe

K=0.9
T=10

% doza gravimetrica cu adaptor

KG=0.16
TG=2
HG=tf(KG,[TG 1])

% venitul pneumatic si convertorul electropneumatic

Kpg=10^-2
KCEKV=0.025
Tv=4
Hpg=tf([0 Kpg],1)
Hv=tf([0 KCEKV],[Tv 1])
% cuptorul
Kc=200+2*n
KTT=0.8
KTZ=0.3
TTZ=120
Tc=600+5*n
tc=0.15*Tc
TTT=100+2*n
tT=0.05*TTT
Hc1=tf(KTZ,[TTZ 1])
Hc2=tf(Kc,[Tc 1],'IoDelay',tc)
Hc3=tf(KTT,[TTT 1],'IoDelay',tT)
% traductoarele de temperatura
KTm=0.16
TTm=4
KTc=0.1
TTc=16
Hp=tf(KTm,[TTm 1])
Hp=tf(KTc,[TTc 1])
%% PATRTEA I
clc

% Consideratii asupra partii fixate
He=tf(1,[Tap 1])
TM_S=TM2+TTT
KM_S=K2*KTT
F1_2=tf(KM_S,[TM_S 1])

% Calculul reg
sigma=0.11
tita=-log(sigma)/(sqrt(pi^2+(log(sigma)^2)))
cv=6.7
wn=2*tita*cv

H02=tf(wn^2,[1 2*tita*wn wn^2])

tr=4/(tita*wn)
dwb=wn*sqrt(1-2*tita^2+sqrt(2-4*tita^2+4*tita^4))
Hf=zpk(tf(Kap*K1*KM_S,conv([Tap 1],conv([TM1 1],[TM1*TM_S 1]))))
Hd=tf(wn^2,conv([1 0],[1 2*tita*wn]))
HR=zpk(tf(wn/(2*tita),[1/(2*tita*wn) 1 0]))
HR1=HR/Hf
H0=zpk(feedback(HR1*Hf,1))
s=tf([1 0],1)
%%
t = 0:0.01:100;
ysim = lsim(H0, t, t)
plot(t,ysim)
title("Ramp Response")
figure
step(H0)
%%
clc
titaprim=0.7921
wnprim=2*titaprim*cv

HRprim=zpk(tf(wnprim/(2*titaprim),[1/(2*titaprim*wnprim) 1 0]))
HR1=HR/Hf
HR1p=zpk(tf(conv([1 100],[1 0.1527]),[1 0])*0.015898)
H02prim=zpk(tf(wnprim^2,[1 2*titaprim*wnprim wnprim^2]))

TMss = TM_S+Tap
Htm = tf(conv([TM1 1], [TMss 1]), Kap*K1*KM_S)
Hr1sec = HR*Htm
H02sec = feedback(Hr1sec, 1)

subplot(311)
step(H02)
subplot(312)
step(H02prim)
subplot(313)
step(H02sec)

figure;
t = 0:0.01:100;
subplot(311)
ysim1 = lsim(H02, t, t);
plot(t, ysim1)
title("Ramp Response")
subplot(312)
ysim2 = lsim(H02prim, t, t);
plot(t, ysim2)
title("Ramp Response")
subplot(313)
ysim3 = lsim(H02sec, t, t);
plot(t, ysim3)
title("Ramp Response")
%% corectie cu dipol
clc

sigma_c=0.1
tita_c=-log(sigma_c)/(sqrt(pi^2+(log(sigma_c)^2)))
cv_c=20
wn_c=2*tita_c*cv_c
H02_c=tf(wn_c^2,[1 2*tita_c*wn_c wn_c^2])
tr_c=4/(tita_c*wn_c)
dwb_c=wn_c*sqrt(1-2*tita_c^2+sqrt(2-4*tita_c^2+4*tita_c^4))
sigma_d=sigma_c - 0.05
tita_d=-log(sigma_d)/(sqrt(pi^2+(log(sigma_d)^2)))
wn_d=dwb_c/sqrt(1-tita_d^2*sqrt(2-tita_d^2+3*tita_d^4))
pc=5/(2*(tita_d/wn_d)-1/cv_c)
zc=pc/(1+5)
tr_d=4/(tita_d*wn_d)
a=2*tita_d*wn_d-pc
b=2*tita_d*wn_d - wn_d^2*5
Hv=zpk(tf([1 a b],1))
beta1=328;
beta2=-38.88
HR2_1=wn_d^2*zpk(tf(conv([1 zc],[1 5]),conv([1 beta1],[1 beta2])))
HR2_2=zpk(tf(conv(conv([Tap 1],[TM1 1]),[TM_S 1]),[1 0]))*(1/(Kap*K1*KM_S))
HR2_d=HR2_1 * HR2_2

H0_d=zpk(feedback(HR2_d*Hf,1))
subplot(211)
step(H0_d)
subplot(212)
t = 0:0.01:100;
ysim_d = lsim(H0_d, t, t);
plot(t, ysim_d)
title("Ramp Response")
%% PARTEA II
clc

Tf = Tap+TM1
Kf = Kap*K1
HH = tf(Kf, [Tf 1])
T1 = TM_S/KM_S
HHH = tf(1,[T1 0])
HF = HH*HHH

% regulator P

bode(HF)
sigmaP=0.13
titaP=-log(sigmaP)/(sqrt(pi^2+(log(sigmaP)^2)))
AP= 1/(4*titaP^2)
dbP=20*log(AP)
wtP=10
wfP=13.4
wn2=2*titaP*wtP
trP=4/(wn2*titaP)
cvP=10^(21.8/20)
dwb_P=wtP
KP=49.2;
figure;
bode(HF)
hold on
bode(KP*HF)
hold off
H0_P=feedback(KP*HF,1)
subplot(211)
step(H0_P)
subplot(212)
t = 0:0.01:100;
ysim_P = lsim(H0_P, t, t);
plot(t, ysim_P)
title("Ramp Response")

% Regulator PI

bode(HF),grid;
sigmaPi=0.02
titaPi=-log(sigmaPi)/(sqrt(pi^2+(log(sigmaPi)^2)))
APi= 1/(4*titaPi^2)
dbPi=20*log(APi)
KPi=16.7
bode(HF)
hold on
bode(HF*KPi)
hold off
wt_pi=4.03
cvPi=4.3
cv_sPi=10
wzPi=0.1*wt_pi
wpPi=cvPi/cv_sPi*wzPi
TpPi=1/wpPi
TzPi=1/wzPi
VrPi=37.3-12.8
Hpi=tf(conv(VrPi,[TzPi 1]),[TpPi 1])
Hpi0=feedback(Hpi*HF,1)
subplot(211)
step(Hpi0)
subplot(212)
t = 0:0.01:100;
ysim_pi = lsim(Hpi0, t, t);
plot(t, ysim_pi)
title("Ramp Response")
trpi = 2/(titaPi^2*wt_pi)

wnPi=2*titaPi*4.3
dwb_Pi=wnPi*sqrt(1-2*titaPi^2+sqrt(2-4*titaPi^2+4*titaPi^4))

% regulator PD

bode(HF),grid;
sigmaPd=0.06;
titaPd=-log(sigmaPd)/(sqrt(pi^2+(log(sigmaPd)^2)))
APd= 1/(4*titaPd^2)
dbPd=20*log(APd)
KPd=19.4
bode(HF);
hold on
bode(HF*KPd);
hold off
grid
wt1Pd=4.63;
trPd=2/(titaPd^2*wt1Pd)
trsPd=0.5
wt2Pd=wt1Pd*(trPd/trsPd)
VrPd=37.3 - 11.53
TdPd=Tf
TNPd=TdPd*(trsPd/trPd)
HPd=tf(conv(VrPd,[TdPd 1]),[TNPd 1])
bode(HF*HPd)
HPd0=feedback(HPd*HF,1)
subplot(211)
step(HPd0)
subplot(212)
t = 0:0.01:100;
ysim_pd = lsim(HPd0, t, t);
plot(t, ysim_pd)
title("Ramp Response")


cvPd=4.6
wnPd=2*titaPd*cvPd
dwb_Pd=wnPd*sqrt(1-2*titaPd^2+sqrt(2-4*titaPd^2+4*titaPd^4))

% Regulator PID

bode(HF),grid;
sigmaPid=0.05
titaPid=-log(sigmaPid)/(sqrt(pi^2+(log(sigmaPid)^2)))
APid= 1/(4*titaPid^2)
dbPid=20*log(APid)
KPid=16.8
bode(HF);
hold on
bode(HF*KPid);
hold off
grid
wt1Pid=4.07
trPid=2/(titaPid^2*wt1Pid)
trsPid=0.5
wt2Pid=wt1Pid*(trPid/trsPid)
Vr1Pid=25.7
TdPid=Tf
TNPid=TdPid*(trsPid/trPid)
H1Pid=tf(conv(VrPd,[TdPd 1]),[TNPd 1])
cvPid=4.16
cvsPid=12
wzPid=0.1*wt2Pid
wpPid=wzPid*(cvsPid/cvPid)
Vr2Pid=37.3-12.88
TpPid=1/wpPid
TzPid=1/wzPid
H2Pid=tf(conv(Vr2Pid,[TzPid 1]),[TpPid 1])
VrPid=Vr1Pid*Vr2Pid
HPid=zpk(H1Pid*H2Pid)
bode(HPid*HF)
HPid0=feedback(HPid*HF,1)
subplot(211)
step(HPid0)
subplot(212)
t = 0:0.01:100;
ysim_pid = lsim(HPid0, t, t);
plot(t, ysim_pid)
title("Ramp Response")

cvPid=4.21
wnPid=2*titaPid*cvPid
dwb_Pid=wnPid*sqrt(1-2*titaPid^2+sqrt(2-4*titaPid^2+4*titaPid^4))
VR = Vr1Pid*Vr2Pid

%% Part 3

Hf3=tf(KCEKV*Kc*KTc,conv(conv([Tv 1],[Tc 1]),[TTc 1]),'IoDelay',tc)

% Regulator Pi

bode(Hf3)
fazaPi=-180+15+50
wtPI=0.00613
TiPi=4/wtPI
KPI=abs(evalfr(Hf3,j*wtPI))
VrPI=1/KPI
HrPI=tf(VrPI,[TiPi 0])+VrPI
HdPi=Hf3*HrPI
wthd=0.00632
bode(HdPi)

fazaPd=-180+50+15
betaPd =0.1
w0Pd=0.0147
K3Pd=abs(evalfr(Hf3,j*w0Pd))
VrPD=sqrt(betaPd)/K3Pd
TdPD=(1/w0Pd)*(1/sqrt(betaPd))
TNPD=betaPd*TdPD
HrPD=VrPD*tf([TdPD 1],[TNPD 1])
HdPd=Hf3*HrPD
bode(HdPd)

% Regulator PID

fazaPid=-180+55+15
w0Pid=0.0147
wprimPid=0.00576
raport=w0Pid/wprimPid
K3Pid1=abs(evalfr(Hf3,j*w0Pid))
K3Pid2=abs(evalfr(Hf3,j*wprimPid))
Vr3Pid=0.228/K3Pid1
To=2*pi/w0Pid
TiPID=1.2*To
TdPID=0.5*To
betaPid =0.2
HrPID=Vr3Pid*tf(conv([TdPID 1],[TiPID 1]),conv([betaPid*TdPID 1],[TiPID 0]))
HdPid=Hf3*HrPID
bode(HdPid)

%% Partea 4

Hd4=HR*tf(Kap*K1*KM_S,conv([Tap 1],conv([TM1 1],[TM_S 1])))


Hd4sm=tf(1,conv([2*Tap 0],[Tap 1]))
Hrpid4=tf(conv([TM1 1],[TM_S 1]),[2*Tap*Kap*K1*KM_S 0])
Hf4=tf(Kap*K1*KM_S,conv([TM1 1],[Tap 1]))
Hr4pi=tf([TM1 1],[2*Tap*Kap*K1*KM_S 0])
H04m=feedback(Hr4pi*Hf4,1)
step(H04m)


Hd4ss=tf([4*Tap 1],conv([8*Tap^2 0 0],[Tap 1]))
Hr4ss=zpk(tf(conv([4*Tap 1],[TM1 1]),[8*Tap^2*Kap*K1*KM_S 0 0]))
H04s=feedback(Hr4ss*Hf4,1)
figure;
step(H04s)