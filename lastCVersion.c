#include <stdio.h>
#include <stdlib.h>

typedef struct  {
    int price;
    int serialNumber;
    char category;
    struct Product* next;
    struct Product* prev;
} Product;

typedef struct {
    int size;
    Product* front;
    Product* rear;
} Deque;

Deque* createDeque() {
    Deque* deque = (Deque*)malloc(sizeof(Deque));
    deque->front = deque->rear = NULL;
    return deque;
}

Product* createProduct(Deque* deque,int price,int serialNumber,char category){
    Product* product = (Product*)malloc(sizeof(Product));
    product->price = price;
    product->serialNumber=serialNumber;
    product->category=category;
    product->next = product->prev = NULL;
    return product;

}

void insertFront(Deque* deque,int price,int serialNumber,char category ) {
    Product* Product = createProduct(deque,price,serialNumber,category);
    if(deque->front == NULL) {
        deque->front = deque->rear = Product;
        Product->next = Product->prev = NULL;
    } else {
        Product->next = deque->front;
        Product->prev = NULL;
        deque->front->prev = Product;
        deque->front = Product;
    }
    ++deque->size;
}

void insertRear(Deque* deque, int price,int serialNumber,char category ) {

    Product* product = createProduct(deque,price,serialNumber,category);
    if(deque->rear == NULL) {
        deque->front = deque->rear = product;
        product->next = product->prev = NULL;
    } else {
        product->prev = deque->rear;
        product->next = NULL;
        deque->rear->next = product;
        deque->rear = product;
    }
    ++deque->size;

}



void deleteFront(Deque* deque) {
    if(isEmpty(deque)) {
        printf("Deque is empty\n");
        return ;
    } else {
        Product* temp = deque->front;
        deque->front = deque->front->next;
        if(deque->front == NULL) {
            deque->rear = NULL;
        } else {
            deque->front->prev = NULL;
        }
        --deque->size;
        free(temp);
        return ;
    }
}

void deleteRear(Deque* deque) {
    if(isEmpty(deque)) {
        printf("Deque is empty\n");
        return;
    } else {
        Product* temp = deque->rear;
        deque->rear = deque->rear->prev;
        if(deque->rear == NULL) {
            deque->front = NULL;
        } else {
            deque->rear->next = NULL;
        }
    --deque->size;
        free(temp);
        return ;
    }
}

Product* getFront(Deque* deque) {
    if(isEmpty(deque)) {
        printf("Deque is empty\n");
        Product* P=NULL;
        return P;
    } else {
        return deque->front;
    }
}
Product* getRear(Deque* deque) {
    if(isEmpty(deque)) {
        printf("Deque is empty\n");
        Product* P=NULL;
        return P;
    } else {
        return deque->rear;
    }
}
int getSize(Deque* deque)
{
    return deque->size;
}

void clear(Deque* deque) {
    while(deque->front != NULL) {
        Product* temp = deque->front;
        deque->front = deque->front->next;
        free(temp);
    }
    deque->rear = NULL;
    free(deque);
}
int isEmpty(Deque* deque)
{
    if(deque->rear == NULL)
        return 1;
    return 0;

}
void display(Deque* deque) {
    if (isEmpty(deque))
    {
        printf("The deque is empty !!\n");
    }
    Product* temp = deque->front;
    while(temp != NULL) {
	    printf("This Price : %d, \
        The category : %d, \
        The setial number : %c \n"
        ,temp->price,temp->serialNumber,temp->category) ;
        temp = temp->next;
    }
    printf("===================================\n");
}

typedef struct{
	Deque* data;
	Deque* view;
	int sz;
}Bar;

void init(Bar* bar);

void add_product(Bar* bar,int price,int serial_number,char category);

void right_arrow(Bar* bar);

void left_arrow(Bar* bar);

Bar* createBar(){
    Bar* bar = (Bar*)malloc(sizeof(Bar));
    bar->data=bar->view=NULL;
}

void init(Bar* bar) {
	bar->data = createDeque();
	bar->view = createDeque();
	bar->sz = 0;
	int n;
	printf("Enter number of initial products :\n");
	scanf("%d", &n);
	for (int i = 0; i < n; i++) {
		printf("Enter price and serial number and category :\n");
		int price ;
		int serial_number ;
		char category ;
		scanf("%d %d %c", &price, &serial_number, &category);
		add_product(bar, price, serial_number, category);
	}
	display(bar->view);
}

void add_product( Bar* bar,int price,int serial_number,char category){
	bar->sz++;
	if (bar->sz <= 6)
		insertRear(bar->view, price,serial_number ,category);
	else
		insertRear(bar->data, price,serial_number ,category);
}

void left_arrow(Bar* bar) {
	if (bar->view->front == NULL || bar->data->rear == NULL) {
		printf("No more data to move left.\n");
		return;
	}

	
	Product *tmp =  getFront(bar->view);

	insertRear(bar->data,tmp->price,tmp->serialNumber,tmp->category);

    deleteFront(bar->view);
	tmp = getFront(bar->data);

	insertRear(bar->view,tmp->price,tmp->serialNumber,tmp->category);
    deleteFront(bar->data);

	display(bar->view);
}

void right_arrow(Bar* bar) {
	if (bar->view->rear == NULL || bar->data->front == NULL) {
		printf("No more data to move right.\n");
		return;
	}

	Product *tmp =  getRear(bar->view);

	insertFront(bar->data,tmp->price,tmp->serialNumber,tmp->category);

    deleteRear(bar->view);
	tmp = getRear(bar->data);

	insertFront(bar->view,tmp->price,tmp->serialNumber,tmp->category);
    deleteRear(bar->data);

	display(bar->view);
}

int main() {
	Bar* bestSellingBar=createBar();
	init(&bestSellingBar);
	char c;
	while (1) {
		printf("Enter 'l' or 'L' to click on the left button,\n'r' or 'R' to click on the right button,\nand any other character to finish: ");
		scanf(" %c", &c);
		if (c == 'l' || c == 'L')
			left_arrow(&bestSellingBar);
		else if (c == 'r' || c == 'R')
			right_arrow(&bestSellingBar);
		else
			break;
	}
	printf("Mission completed successfully!!!\n");
	return 0;
}