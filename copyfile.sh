#!/bin/bash

scp ./freelist-lru.c A0119656@angsana.comp.nus.edu.sg:~/assign1
ssh A0119656@angsana.comp.nus.edu.sg "cd ~/assign1; make freelist-lru.o"