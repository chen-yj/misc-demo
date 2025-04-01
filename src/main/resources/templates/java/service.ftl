package ${packageName}.service;

import ${packageName}.dao.${javaTableName}Dao;
import ${packageName}.dto.${javaTableName}CreateDto;
import ${packageName}.dto.${javaTableName}Query;
import ${packageName}.dto.${javaTableName}UpdateDto;
import ${packageName}.entity.${javaTableName};
import ${packageName}.enums.StatusEnum;
import ${packageName}.result.DescribeException;
import ${packageName}.result.ExceptionEnum;
import ${packageName}.utils.PageableUtil;
import jakarta.persistence.criteria.Predicate;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
@Slf4j
public class ${javaTableName}Service {

    @Autowired
    private ${javaTableName}Dao ${lowerName}Dao;

    public void create(${javaTableName}CreateDto vo) {
        log.info("save ${lowerName}: {}", vo);
        if (${lowerName}Dao.existsByCode(vo.getCode())) {
            throw new DescribeException(ExceptionEnum.CODE_EXISTS);
        }
        ${javaTableName} ${lowerName} = new ${javaTableName}();
        BeanUtils.copyProperties(vo, ${lowerName});
        ${lowerName}.setStatus(StatusEnum.NORMAL.getCode());
        ${lowerName}Dao.save(${lowerName});
    }

    public void update(${javaTableName}UpdateDto vo) {
        log.info("update ${lowerName}: {}", vo);
        if (${lowerName}Dao.existsByIdNotAndCode(vo.getId(), vo.getCode())) {
            throw new DescribeException(ExceptionEnum.CODE_EXISTS);
        }
        Optional<${javaTableName}> ${lowerName}Opt = ${lowerName}Dao.findById(vo.getId());
        if (${lowerName}Opt.isEmpty()) {
            throw new DescribeException(ExceptionEnum.DATA_NOT_FOUND);
        }
        ${javaTableName} ${lowerName} = ${lowerName}Opt.get();
        BeanUtils.copyProperties(vo, ${lowerName});
        ${lowerName}Dao.save(${lowerName});
    }

    public ${javaTableName} get(Long id) {
        log.info("get ${lowerName}: {}", id);
        Optional<${javaTableName}> ${lowerName}Opt = ${lowerName}Dao.findById(id);
        if (${lowerName}Opt.isEmpty()) {
            throw new DescribeException(ExceptionEnum.DATA_NOT_FOUND);
        }
        return ${lowerName}Opt.get();
    }

    public void delete(List<Long> ids) {
        log.info("delete ${lowerName}: {}", ids);
        int count = ${lowerName}Dao.deleteByIdIn(ids);
        log.info("delete ${lowerName} count: {}", count);
    }

    public Page<${javaTableName}> search(${javaTableName}Query query) {
        Pageable pageable = PageableUtil.change(query.getPage(), query.getSize(), "id", "desc");
        Page<${javaTableName}> page = ${lowerName}Dao.findAll(where(query), pageable);
        return page;
    }

    private Specification<${javaTableName}> where(${javaTableName}Query qry) {
        return (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();
<#list entityDefines as define>
    <#if define.type == "String">
            if (StringUtils.isNotBlank(qry.get${define.name?cap_first}())) {
                predicates.add(cb.like(root.get("${define.name}"), "%" + qry.get${define.name?cap_first}() + "%"));
            }
    <#else>
            if (qry.get${define.name?cap_first}() != null) {
                predicates.add(cb.equal(root.get("${define.name}"), qry.get${define.name?cap_first}()));
            }
    </#if>
</#list>
            if (qry.getStartTime() != null) {
                predicates.add(cb.greaterThanOrEqualTo(root.get("createTime"), qry.getStartTime()));
            }
            if (qry.getEndTime() != null) {
                predicates.add(cb.lessThanOrEqualTo(root.get("createTime"), qry.getEndTime()));
            }
            return query.where(predicates.toArray(new Predicate[0])).getRestriction();
        };
    }
}
