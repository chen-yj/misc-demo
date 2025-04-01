package com.chenyj.misc;

import com.chenyj.misc.generate.service.GenerateService;
import freemarker.template.TemplateException;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.io.IOException;

@SpringBootTest
public class GenerateCodeTest {

    @Autowired
    private GenerateService generateService;

    @Test
    public void createBack() throws IOException, TemplateException {
        String baseDir = "D:/ws/misc-demo/src/main/java/";
        String packageName = "com.chenyj.misc.demo";
        String javaTableNames = "DeviceSubscription";
        // 类型|名称|可为空|描述
//        String entityDefineStr = "string|name|false#" +
//                "string|phone|false#" +
////                "string|description#" +
////                "integer|status||status, 0: normal, 1: frozen#" +
//                "long|roomId|false|Related room id#";
////                + "integer|defaultFlag||default flag, 1: default#";
//        String entityDefineStr = "long|deviceId|false|device id#" +
//                "long|messageId|false|message id#" +
//                "integer|type|false|alarm type#" +
//                "string|message|false#" +
//                "date|time|false#" +
//                "integer|processState|false|process state 0: unprocessed, 1: processed#" +
//                "date|processTime|false#";
        String entityDefineStr = "long|deviceId|false|device id#" +
                "long|duration||subscription duration, unit: second, scope: 1-3600#" +
                "String|types|false|subscription types#" +
                "long|typesLong|false|subscription types in bit to decimal#" +
                "long|subscriptionId|false|subscription id#" +
                "string|reference||subscription description#" +
                "date|subscriptionTime||subscription time#" +
                "date|terminationTime||termination time#" +
                "long|supportType||device support subscription types in bit to decimal#";


        for (String javaTableName : javaTableNames.split(",")) {
            generateService.createJava(baseDir, packageName, javaTableName, entityDefineStr);
        }
        System.out.println("执行完毕");
    }

    @Test
    public void createFront() throws IOException, TemplateException {
        String baseDir = "D:/ws/misc-demo/src/java/resources/demo/vue/";
        String packageName = "com.chenyj.misc";
        String javaTableNames = "DeviceAlarm";
        // 类型|名称|可为空|描述
//        String entityDefineStr = "string|name|false#" +
////                "string|code|false#" +
//                "string|phone|false#" +
//                "string|description#" +
////                "integer|status||status, 0: normal, 1: frozen#" +
////                "long|customerId|false|Related customer id#";
////                "long|projectId|false|Related project id#";
//                "long|roomId|false|Related room id#";
////                + "integer|defaultFlag||default flag, 1: default#";
        String entityDefineStr = "long|deviceId|false|device id#" +
                "long|messageId|false|message id#" +
                "integer|type|false|alarm type#" +
                "string|message|false#" +
                "date|time|false#" +
                "integer|processState|false|process state 0: unprocessed, 1: processed#" +
                "date|processTime|false#";

        for (String javaTableName : javaTableNames.split(",")) {
            generateService.createVue(baseDir, packageName, javaTableName, entityDefineStr);
        }
        System.out.println("执行完毕");
    }
}
