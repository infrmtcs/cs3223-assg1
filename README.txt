1) Team members
Nguyen Huu Thanh A0112069M
Duong Thanh Dat A0119656W

2) Description
2.1) Overview
We create a new link list that keeps buffer_id in each Node.
Everytime we update a stackNode, it will be move to the tail of of the list.  To get a buffer, we will find a non-null stackNode from the head to return its buffer_id.
StrategyUpdateAccessedBuffer is put in StrategyGetBuffer, StrategyFreeBuffer.

2.2) New structure

Link list node structure:

typedef struct StackNode StackNode;
struct StackNode
{
	StackNode  *next;
	StackNode  *prev;
	int		buf_id;
	bool 		is_free;
};

Inside BufferStrategyControl class:
StackNode	stackTop   //This is for keeping the head of the list. This is a dummy head. Buffer element will be from stackTop->next onwards.
StackNode 	stack[1]     //This array is static StackNode to be allocated to StackNode list. This is implemented using variable length array trick.

2.3)
Functions modified:

StrategyUpdateAccessedBuffer(int buf_id, bool delete)
We will update, delete, and add StackNode in this function
We do a search throughout the list to find the StackNode keeping buf_id. Then we take that node out of the list
If delete is true, we will not push that node back.
If buf_id is not in the list, we will consider this case as adding new StackNode to the list. We get a free stack new free StackNode from BufferStrategyControl->stack.
In both updating and adding case, the new node will then push to the tail of the list.

StrategyGetBuffer(BufferAccessStrategy strategy, bool *lock_held)
We modified “Clock Sweep Algorithm” part to “LRU part” as follow
Start from BufferStrategyControl->stackTop, we check each stackNode if it is null or not. If the stackNode is not Null, the buffer that StackNode is keeping will be returned

StrategyInitialize(bool init)
We set every variable we use to 0 and NULL.

StrategyShmemSize(void)
Add size of link list
size = add_size(size, MAXALIGN(sizeof(StackNode) * NBuffers));

StrategyFreeBuffer(volatile BufferDesc *buf)
Add StrategyUpdateAccessedBuffer inside the function.
