%% Kennissystemen 2014-2015
%% Assignment 3 - MC4
%% Markus Pfundstein (10452397)
%% Thomas Meijers (10647023)
%%
%% Knowledge base for assignment 3.

%%% Log known diseases

disease(malaria).
disease(malaria_tropica).
disease(malaria_quartana).
disease(giardasis).
disease(bacillaire_dysenterie).
disease(tyfus).
disease(aarsmaden).

%%% MALARIA

if malaria_tropica then malaria.

if malaria_tertiana then malaria.

if malaria_quartana then malaria.

% mapping symptoms to disease

if hoge_korts and transpireert and koude_rillingen then malaria_aanval.

if malaria_aanval and dagelijks_koorts then malaria_tropica.

if malaria_aanval and regelmatig_koorts_48_uur then malaria_tertiana.

if malaria_aanval and regelmatig_koorts_72_uur then malaria_quartana.

%% DARMAANDOENINGEN

if buikklachten or klachten_ontlasting then darm_aandoening.

%% Giardasis
if darm_aandoening and diarree then giardasis.

%% Bacillaire dysenterie
if darm_aandoening and hoge_koorts then bacillaire_dysenterie.

%% Tyfus
if darm_aandoening and hoge_koorts and hoofdpijn then tyfus.

%%% WORMEN

%% Aarsmaden
if jeukende_anus and wormen then aarsmaden.

%% symptom tree
if hoge_koorts then koorts.

if waterdunne_diarree then diarree.

if diarree then klachten_ontlasting.

if brijige_ontlasting then klachten_ontlasting.

if bloedige_ontlasting then klachten_ontlasting.

if buikpijn then buikklachten.

if misseljk then buikklachten.

if heftige_kramp then buikklachten.

if obstipatie then buikklachten.

if hoofdpijn then klachten_algemeen.

%% mapping abstract input to symptoms

if temperatur_hoger_38_5 then koorts.

if temperatur_hoger_40 then hoge_koorts.

if wormen_in_ontlasting then wormen.

if eitjes_in_ontlasting then wormen.