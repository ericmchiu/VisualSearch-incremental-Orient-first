function quit_experiment()
global vs_figure 
global all_responses

text(100,400,'Congratualtions!','Fontsize', 60)
text(100,550,'You have completed this experiment block,','Fontsize', 60)
text(100,700,'please notify the experimenter.','Fontsize', 60)
data = dir('subjects/subject1_*');
save(['subjects/subject1_' int2str(length(data)+1)],'all_responses','-ASCII');
pause(10)
close(vs_figure)