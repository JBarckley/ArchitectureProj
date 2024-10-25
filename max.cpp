int max(int* arr, int* endarr){
    int max = *arr;
    for (arr += sizeof(int); arr < endarr; arr += sizeof(int)){
        if (*arr > max){
            max = *arr;
        }
    }
    return max;
}