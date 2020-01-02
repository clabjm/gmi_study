#################
# Heuristic selection of microbiota marker traits
# spearman correlation > 0.5 adjacency matrix�� ����
# �� trait�� degree(True�� ����)�� ����
# ���� ���� degree�� 'final marker?(������ ��, ���� ����)'�� ����
# network (= adjacency matrix)���� final marker�� �װͰ� ����� nodes (= traits)�� ������ ��
# �� ������ �ݺ��� (������ break �� �� ������, �켱�� edge�� �ִ� ��� ��� selection)
# 1 �ܰ迡�� adjacency matrix ������ -2 step���� �����ߴ� nodes�� �������Ͽ� ����
#################

args=commandArgs(TRUE)

input_path <- args[1]

dat <- read.table(args[1],sep=",",row.names=1,head=T)

mat <- as.matrix(dat)

# upper diagonal matrix �̿�
mat[lower.tri(mat)] <- -9
diag(mat) <- -9

rm_nodes <- c()
itr <- 0
rm_nodes_index <- c()
tmp_rm_nodes_index <- NA
tmp_mat <- mat
traits_nm <- rownames(mat)

while(TRUE){
  itr <- itr + 1
  print(itr)
  print(rm_nodes)
  if(itr == 1) tmp_mat <- mat else {
    tmp_mat <- mat[-c(rm_nodes_index,tmp_rm_nodes_index),-c(rm_nodes_index,tmp_rm_nodes_index)]
  }
  adj_mat <- tmp_mat > 0.4
  dgrees <- rowSums(adj_mat)
  print(max(dgrees))
  if(all(dgrees == 0)) break
  
  rm_nodes <- c(rm_nodes,names(which.max(dgrees)))
  rm_nodes_index <- c(rm_nodes_index,which(traits_nm == names(which.max(dgrees))))
  
  tmp_rm_nodes_index <- which(traits_nm %in% names(which(adj_mat[which.max(dgrees),] > 0)))
}

# python���� ���� �� �ֵ��� txt�� ����
write.table(unique(rm_nodes),"heuristic_selected_marker.txt",row.names=F,col.names=F,quote=F,sep=",")