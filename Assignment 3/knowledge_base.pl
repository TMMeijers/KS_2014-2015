%% Kennissystemen 2014-2015
%% Assignment 3 - MC4
%% Markus Pfundstein (10452397)
%% Thomas Meijers (10647023)
%%
%% Knowledge base for assignment 3.

if malaria_tropica then malaria.

if malaria_tertiana then malaria.

if malaria_quartana then malaria.

% mapping symptoms to disease

if hoge_korts and transpireert and koude_rillingen then malaria_aanval.

if malaria_aanval and dagelijks_korts then malaria_tropica.

if malaria_aanval and regelmatig_korts_48_uur then malaria_tertiana.

if malaria_aanval and regelmatig_korts_72_uur then malaria_qartana.

%% symptom tree
if hoge_korts then korts.

%% mapping abstract input to symptoms

if temperatur_hoger_38_5 then korts.

if temperatur_hoger_40 then hoge_korts.

