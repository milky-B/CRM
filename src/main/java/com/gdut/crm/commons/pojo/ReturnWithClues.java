package com.gdut.crm.commons.pojo;

import com.gdut.crm.pojo.workbench.Clue;

import java.util.List;

public class ReturnWithClues {
    private int amount;
    private List<Clue> clueList;
    public int getAmount() {
        return amount;
    }

    public void setAmount(int amount) {
        this.amount = amount;
    }

    public List<Clue> getClueList() {
        return clueList;
    }

    public void setClueList(List<Clue> clueList) {
        this.clueList = clueList;
    }


 }
