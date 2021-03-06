%verify "executed"
%verify "null object"
    /* For: iput-object-quick */
    # op vA, vB, offset                    /* CCCC */
    GET_OPB(a2)                            #  a2 <- B
    GET_VREG(a3, a2)                       #  a3 <- fp[B], the object pointer
    FETCH(a1, 1)                           #  a1 <- field byte offset
    GET_OPA4(a2)                           #  a2 <- A(+)
    beqz      a3, common_errNullObject     #  object was null
    GET_VREG(a0, a2)                       #  a0 <- fp[A]
    FETCH_ADVANCE_INST(2)                  #  advance rPC, load rINST
    addu      t0, a3, a1
    sw        a0, 0(t0)                    #  obj.field (always 32 bits) <- a0
    beqz      a0, 1f
    lw        a2, offThread_cardTable(rSELF) #  a2 <- card table base
    srl       t1, a3, GC_CARD_SHIFT
    addu      t2, a2, t1
    sb        a2, 0(t2)
1:
    GET_INST_OPCODE(t0)                    #  extract opcode from rINST
    GOTO_OPCODE(t0)                        #  jump to next instruction
