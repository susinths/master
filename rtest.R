a = 1
b = 2
c = a + b

a = rnorm(1000)

plot(a, type = 'l')

df = read.csv('/home/susinths/Documents/sync/drive/docs/ifi/master/results/data_collect_test.dat', header = FALSE)


plot(df$V1, df$V9, type = 'o')
barplot(df$V9)

# ggplot

setwd('/home/susinths/Documents/sync/drive/docs/ifi/master/results')

pdf('test.pdf', width=7, height=5)
plot(df$V1, df$V9, type = 'l',col.lab="red", fg="blue)
dev.off()



