package ${packageName}.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.persistence.*;
import lombok.Data;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.time.LocalDateTime;

@Schema(description = "${javaTableName} entity")
@Data
@Entity
@Table(name = "${tableName}")
@EntityListeners(AuditingEntityListener.class)
public class ${javaTableName} {

    @Schema(description = "primary key")
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

<#list entityDefines as define>
    @Schema(description = "${define.desc}")
    private ${define.type} ${define.name};
    <#if define_has_next>
    <#-- 增加一个空行 -->

    </#if>
</#list>

    @Schema(description = "Create time")
    @CreatedDate
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime createTime;

    @Schema(description = "Update time")
    @LastModifiedDate
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime updateTime;
}
