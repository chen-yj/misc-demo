package com.chenyj.misc.generate.util;

import com.chenyj.misc.generate.dto.EntityDefine;
import org.apache.commons.lang3.StringUtils;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

public class GenerateUtils {

    public static List<EntityDefine> getEntityDefineList(String javaTableName, String defineStr) {
        List<EntityDefine> entityDefines = new ArrayList<>();
        String[] defines = defineStr.split("#");
        for (String define : defines) {
            String[] split = define.split("\\|");
            EntityDefine entityDefine = new EntityDefine();
            entityDefine.setType(capitalizeFirstLetter(split[0]));
            entityDefine.setName(split[1]);
            if (split.length > 2) {
                if (StringUtils.isNotBlank(split[2])) {
                    entityDefine.setNullable(Boolean.parseBoolean(split[2]));
                }
            }
            if (split.length > 3) {
                entityDefine.setDesc(split[3]);
            } else {
                entityDefine.setDesc(javaTableName + " " + split[1]);
            }
            entityDefines.add(entityDefine);
        }
        return entityDefines;
    }

    public static String capitalizeFirstLetter(String input) {
        if (input == null || input.isEmpty()) {
            return input;
        }
        return input.substring(0, 1).toUpperCase(Locale.ROOT) + input.substring(1);
    }

    public static String camelToSnake(String camelCase) {
        if (camelCase == null || camelCase.isEmpty()) {
            return camelCase;
        }
        return StringUtils.join(
                StringUtils.splitByCharacterTypeCamelCase(camelCase), "_"
        ).toLowerCase();
    }

    public static String firstLetterToLowerCase(String str) {
        if (str == null || str.isEmpty()) {
            return str; // 空字符串或null，直接返回
        }
        return str.substring(0, 1).toLowerCase() + str.substring(1);
    }
}
