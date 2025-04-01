package com.chenyj.misc.generate.dto;

import lombok.Data;

@Data
public class EntityDefine {

    private String type;

    private String name;

    private boolean nullable = true;

    private String desc;
}
