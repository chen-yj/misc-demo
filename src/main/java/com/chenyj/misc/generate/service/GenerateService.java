package com.chenyj.misc.generate.service;

import com.chenyj.misc.generate.util.GenerateUtils;
import freemarker.cache.ClassTemplateLoader;
import freemarker.template.Configuration;
import freemarker.template.Template;
import freemarker.template.TemplateException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.util.HashMap;
import java.util.Map;

@Service
@Slf4j
public class GenerateService {

    Configuration cfgJava = null;

    {
        cfgJava = new Configuration(Configuration.VERSION_2_3_30);
        cfgJava.setTemplateLoader(new ClassTemplateLoader(GenerateService.class, "/templates/java/"));
        cfgJava.setDefaultEncoding("UTF-8");
    }

    Configuration cfgVue = null;

    {
        cfgVue = new Configuration(Configuration.VERSION_2_3_30);
        cfgVue.setTemplateLoader(new ClassTemplateLoader(GenerateService.class, "/templates/vue/"));
        cfgVue.setDefaultEncoding("UTF-8");
    }

    public void createJava(String baseDir, String packageName, String javaTableName, String entityDefineStr) throws IOException, TemplateException {
        Template entityTemplate = cfgJava.getTemplate("entity.ftl");
        Template daoTemplate = cfgJava.getTemplate("dao.ftl");
        Template serviceTemplate = cfgJava.getTemplate("service.ftl");
        Template controllerTemplate = cfgJava.getTemplate("controller.ftl");

        Template createVoTemplate = cfgJava.getTemplate("createDto.ftl");
        Template updateVoTemplate = cfgJava.getTemplate("updateDto.ftl");
        Template queryTemplate = cfgJava.getTemplate("query.ftl");

        Map<String, Object> context = new HashMap<>();
        context.put("packageName", packageName);
        context.put("javaTableName", javaTableName);
        context.put("entityDefines", GenerateUtils.getEntityDefineList(javaTableName, entityDefineStr));
        context.put("tableName", "t_" + GenerateUtils.camelToSnake(javaTableName));
        context.put("lowerName", GenerateUtils.firstLetterToLowerCase(javaTableName));

        generateJava(entityTemplate, context, baseDir + packageName.replace(".", "/") + "/entity");
        generateJava(daoTemplate, context, baseDir + packageName.replace(".", "/") + "/dao");
        generateJava(serviceTemplate, context, baseDir + packageName.replace(".", "/") + "/service");
        generateJava(controllerTemplate, context, baseDir + packageName.replace(".", "/") + "/controller");
        generateJava(createVoTemplate, context, baseDir + packageName.replace(".", "/") + "/dto");
        generateJava(updateVoTemplate, context, baseDir + packageName.replace(".", "/") + "/dto");
        generateJava(queryTemplate, context, baseDir + packageName.replace(".", "/") + "/dto");
    }

    private void generateJava(Template template, Map<String, Object> context, String path) throws IOException, TemplateException {
        File folder = new File(path);
        if (!folder.exists()) {
            folder.mkdirs();
        }
        String javaFileName = GenerateUtils.capitalizeFirstLetter(template.getName()).replace(".ftl", ".java");
        if (javaFileName.contains("Entity")) {
            javaFileName = javaFileName.replace("Entity", "");
        }
        String fileName = path + "/" + context.get("javaTableName") + javaFileName;
        FileOutputStream fos = new FileOutputStream(fileName);
        OutputStreamWriter out = new OutputStreamWriter(fos);
        template.process(context, out);
        fos.close();
        out.close();
    }

    public void createVue(String baseDir, String packageName, String javaTableName, String entityDefineStr) throws IOException, TemplateException {
        Template apijsTemplate = cfgVue.getTemplate("api.js.ftl");
        Template indexTemplate = cfgVue.getTemplate("index.vue.ftl");
        Template editTemplate = cfgVue.getTemplate("edit.vue.ftl");

        Map<String, Object> context = new HashMap<>();
        context.put("packageName", packageName);
        context.put("javaTableName", javaTableName);
        context.put("entityDefines", GenerateUtils.getEntityDefineList(javaTableName, entityDefineStr));
        context.put("tableName", "t_" + GenerateUtils.camelToSnake(javaTableName));
        context.put("lowerName", GenerateUtils.firstLetterToLowerCase(javaTableName));

        generateVue(apijsTemplate, context, baseDir + packageName.replace(".", "/"));
        generateVue(indexTemplate, context, baseDir + packageName.replace(".", "/"));
        generateVue(editTemplate, context, baseDir + packageName.replace(".", "/"));
    }

    private void generateVue(Template template, Map<String, Object> context, String path) throws IOException, TemplateException {
        File folder = new File(path);
        if (!folder.exists()) {
            folder.mkdirs();
        }
        String vueFileName = template.getName().replace(".ftl", "");
        if (vueFileName.contains("js")) {
            vueFileName = context.get("lowerName") + "." + vueFileName;
        }
        String fileName = path + "/" + vueFileName;
        FileOutputStream fos = new FileOutputStream(fileName);
        OutputStreamWriter out = new OutputStreamWriter(fos);
        template.process(context, out);
        fos.close();
        out.close();
    }
}
