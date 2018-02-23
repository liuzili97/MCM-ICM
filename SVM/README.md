# Usage
If you want to divide some data into two groups supervised, you need to divide the marked-data into training data and test data. For example,<br><br>
`train=[5 5; 6 4; 5 6; 5 4; 4 5; 8 5; 8 8; 4 5; 5 7; 7 8; 1 2; 1 4; 4 2; 5 1.5; 7 3; 10 4; 4 9; 2 8; 8 9; 8 10];` <br>
`group=[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2];`  <br>
`test=[6 6; 5.5 5.5; 7 6; 12 14; 7 11; 2 2; 9 9; 8 2; 2 6; 5 10; 4 7; 7 4];` <br>
`groupTest=[1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 1, 1];`<br><br>
After setting the kernel function, such as `linear, rbf, quadratic, polynomial and so on`, you can train the classifier and test it, as is shown in the figure. <br>



