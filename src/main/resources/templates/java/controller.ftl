package ${packageName}.controller;

import ${packageName}.dto.${javaTableName}CreateDto;
import ${packageName}.dto.${javaTableName}Query;
import ${packageName}.dto.${javaTableName}UpdateDto;
import ${packageName}.entity.${javaTableName};
import ${packageName}.enums.BusinessType;
import ${packageName}.log.Log;
import ${packageName}.result.DescribeException;
import ${packageName}.result.ExceptionEnum;
import ${packageName}.result.Result;
import ${packageName}.result.ResultUtil;
import ${packageName}.service.${javaTableName}Service;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.collections4.CollectionUtils;
import org.springdoc.core.annotations.ParameterObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Tag(name = "${javaTableName} management")
@RestController
@RequestMapping("/${lowerName}")
@Slf4j
public class ${javaTableName}Controller {

    @Autowired
    private ${javaTableName}Service ${lowerName}Service;

    @Log(title = "${javaTableName} create", businessType = BusinessType.INSERT)
    @Operation(summary = "${javaTableName} create")
    @PostMapping(value = "/create")
    public Result<Object> create(@RequestBody @Valid ${javaTableName}CreateDto dto) {
        try {
            ${lowerName}Service.create(dto);
            return ResultUtil.success();
        } catch (DescribeException e) {
            log.warn("${javaTableName} create fail: {}", e.getMessage());
            return ResultUtil.error(e.getCode(), e.getMessage());
        } catch (Exception e) {
            log.error("${javaTableName} create error", e);
            return ResultUtil.error(ExceptionEnum.UNKNOWN_ERROR);
        }
    }

    @Log(title = "${javaTableName} update", businessType = BusinessType.UPDATE)
    @Operation(summary = "${javaTableName} update")
    @PostMapping(value = "/update")
    public Result<Object> update(@RequestBody @Valid ${javaTableName}UpdateDto dto) {
        try {
            ${lowerName}Service.update(dto);
            return ResultUtil.success();
        } catch (DescribeException e) {
            log.warn("${javaTableName} update fail: {}", e.getMessage());
            return ResultUtil.error(e.getCode(), e.getMessage());
        } catch (Exception e) {
            log.error("${javaTableName} update error", e);
            return ResultUtil.error(ExceptionEnum.UNKNOWN_ERROR);
        }
    }

    @Operation(summary = "${javaTableName} detail")
    @GetMapping(value = "/detail")
    public Result<${javaTableName}> detail(@RequestParam Long id) {
        return ResultUtil.success(${lowerName}Service.get(id));
    }

    @Log(title = "${javaTableName} delete", businessType = BusinessType.DELETE)
    @Operation(summary = "${javaTableName} delete")
    @DeleteMapping(value = "/delete")
    public Result<Object> delete(@RequestBody List<Long> ids) {
        if (CollectionUtils.isEmpty(ids)) {
            return ResultUtil.error(ExceptionEnum.ILLEGAL_PARAM);
        }
        try {
            ${lowerName}Service.delete(ids);
            return ResultUtil.success();
        } catch (Exception e) {
            log.error("${javaTableName} delete error", e);
            return ResultUtil.error(ExceptionEnum.UNKNOWN_ERROR);
        }
    }

    @Operation(summary = "${javaTableName} search")
    @GetMapping(value = "/search")
    public Result<Page<${javaTableName}>> search(@ParameterObject ${javaTableName}Query query) {
        try {
            return ResultUtil.success(${lowerName}Service.search(query));
        } catch (Exception e) {
            log.error("${javaTableName} search error", e);
            return ResultUtil.error(ExceptionEnum.UNKNOWN_ERROR);
        }
    }
}
