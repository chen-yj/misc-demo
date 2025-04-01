package ${packageName}.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Schema(description = "${javaTableName} create dto")
@Data
public class ${javaTableName}CreateDto {

<#list entityDefines as define>
    @Schema(description = "${define.desc}")
<#if define.nullable == false>
    @NotBlank(message = "${javaTableName} ${define.name} cannot be empty")
</#if>
<#if define.type == "String">
    @Size(max = 255)
</#if>
    private ${define.type} ${define.name};
    <#if define_has_next>
    <#-- 增加一个空行 -->

    </#if>
</#list>
}
