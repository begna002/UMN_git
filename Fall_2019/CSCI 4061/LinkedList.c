#include<stdio.h>
#include<stdlib.h>
#include <ctype.h>


struct Node{
  int data;
  struct Node * next;
};

void addData(struct Node ** current, struct Node * newNode) {
  struct Node* head;
  if (*current == NULL || newNode->data <= (*current)->data) {
    newNode->next = *current;
    *current = newNode;
  } else {
    head = *current;
    while (head->next != NULL && head->next->data < newNode->data) {
      head = head->next;
    }
    newNode->next = head->next;
    head->next = newNode;
  }
};

struct Node *new_Node(int new_data)
{
    struct Node* new_node =
        (struct Node*) malloc(sizeof(struct Node));
    new_node->data  = new_data;
    new_node->next =  NULL;

    return new_node;
}

void printList(struct Node *head) {
  struct Node *temp = head;
  while(temp != NULL) {
    printf("%d  ", temp->data);
    temp = temp->next;
  }
}

int main(int argc, char *argv[]) {
  if (argc == 1) {
    fprintf(stderr, "No arguments given\n");
  }
  struct Node* current = NULL;
  struct Node *newNode;
  for (int i = 1; i < argc; i++) {
    if (atoi(argv[i])) {
      int value = atoi(argv[i]);
      newNode = new_Node(atoi(argv[i]));
      addData(&current, newNode);
    } else {
      fprintf(stderr, "Value at index %d is not an integer. Not including...\n",
       i);
    }
  }
  printList(current);
  return 0;
}
