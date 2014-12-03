function quit_practice_0()
global vs_figure 
global all_responses

text(100,400,'You have completed this practice block,','Fontsize', 60)
text(100,550,'please notify the experimenter.','Fontsize', 60)
data = dir('subjects/practice1_*');
save(['subjects/practice1_' int2str(length(data)+1)],'all_responses','-ASCII');
pause(10)
close(vs_figure)