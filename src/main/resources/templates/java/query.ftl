package ${packageName}.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import org.springframework.format.annotation.DateTimeFormat;

import java.util.Date;

@Schema(description = "${javaTableName} query dto")
@Data
public class ${javaTableName}Query {

<#list entityDefines as define>
    @Schema(description = "${define.desc}")
    private ${define.type} ${define.name};
    <#if define_has_next>
    <#-- 增加一个空行 -->

    </#if>
</#list>

    @Schema(description = "start time, format: yyyy-MM-dd HH:mm:ss")
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date startTime;

    @Schema(description = "end time, format: yyyy-MM-dd HH:mm:ss")
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date endTime;

    @Schema(description = "page, default 1")
    private int page = 1;

    @Schema(description = "size, default 10")
    private int size = 10;
}
