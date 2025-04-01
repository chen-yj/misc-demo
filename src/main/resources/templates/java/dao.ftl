package ${packageName}.dao;

import ${packageName}.entity.${javaTableName};
import jakarta.transaction.Transactional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@Transactional
public interface ${javaTableName}Dao extends JpaRepository<${javaTableName}, Long>, JpaSpecificationExecutor<${javaTableName}> {

    boolean existsByCode(String code);

    boolean existsByIdNotAndCode(Long id, String code);

    int deleteByIdIn(List<Long> ids);
}
