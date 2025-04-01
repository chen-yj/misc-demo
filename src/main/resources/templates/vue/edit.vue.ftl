<template>
  <div>
    <el-dialog v-model="dialogVisible" :title="datas.Tips" width="30%" draggable :before-close="handleClose" :close-on-click-modal="false">
      <el-form :model="datas.submitForm" label-width="100px" :rules="rules" ref="ruleFormRef">
<#list entityDefines as define>
  <#if define.name == "code">
        <el-col :span="20">
          <el-form-item label="Code" prop="code">
            <el-input v-model="datas.submitForm.code" maxlength="30" clearable :disabled="!!data.id" placeholder="Please input code" />
          </el-form-item>
        </el-col>
  <#elseif define.name == "status">
        <el-col :span="20" v-if="data.id">
          <el-form-item label="Status" prop="status">
            <el-switch
              v-model="datas.submitForm.status"
              inline-prompt
              style="--el-switch-on-color: #13ce66; --el-switch-off-color: #ff4949"
              :active-value="0"
              :inactive-value="1"
              active-text="Normal"
              inactive-text="Frozen"
              :disabled="show"
            />
          </el-form-item>
        </el-col>
  <#else>
    <#if define.nullable == false>
        <el-col :span="20">
          <el-form-item label="${define.name?cap_first}" prop="${define.name}">
            <el-input v-model="datas.submitForm.${define.name}" maxlength="30" clearable :disabled="show" placeholder="Please input ${define.name}" />
          </el-form-item>
        </el-col>
    <#else>
        <el-col :span="20">
          <el-form-item label="${define.name?cap_first}" prop="${define.name}">
            <el-input v-model="datas.submitForm.${define.name}" maxlength="30" clearable :disabled="show" />
          </el-form-item>
        </el-col>
    </#if>
  </#if>
</#list>
        <el-col :span="20">
          <el-form-item label="Reseller" prop="resellerId">
            <el-select v-model="datas.submitForm.resellerId" placeholder="Please select reseller" :disabled="show">
              <el-option v-for="item in resellers" :key="item.id" :label="item.name" :value="item.id" />
            </el-select>
          </el-form-item>
        </el-col>
        <el-col :span="20" v-if="show">
          <el-form-item label="Create time" prop="createTime">
            <el-input v-model="datas.submitForm.createTime" disabled />
          </el-form-item>
        </el-col>
        <el-col :span="20" v-if="show">
          <el-form-item label="Update time" prop="updateTime">
            <el-input v-model="datas.submitForm.updateTime" disabled />
          </el-form-item>
        </el-col>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="handleClose">{{ $t('lang.common.cancel') }}</el-button>
          <el-button type="primary" @click="save(ruleFormRef)" :loading="datas.loading" v-if="!show">
            {{ $t('lang.common.comfirm') }}
          </el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
  import { useUserStore } from '@/stores/userStore'
  import { ref, reactive, getCurrentInstance } from 'vue'
  import { ElMessageBox, FormRules, FormInstance } from 'element-plus'
  import { useCallback } from '@/hooks/useCallback'
  import { useConfirm } from '@/hooks/useConfirm'
  const { proxy } = getCurrentInstance() as any
  const $t = proxy.$t
  const emit = defineEmits(['success', 'close'])
  const { editData, isShow } = defineProps<Props>()
  let data = { ...editData }
  let show = isShow
  const userStore = useUserStore()
  interface Props {
    editData: any
    isShow: boolean
  }
  interface Datas {
    loading: boolean
    Tips: string
    submitForm: any
    options: any
    selectList: any
  }
  let datas: Datas = reactive({
    loading: false,
    Tips: 'Create ${lowerName}',
    options: [],
    selectList: [],
    submitForm: {
<#list entityDefines as define>
    <#if define.type == "String">
      ${define.name}: '',
    <#else>
      ${define.name}: 0,
    </#if>
</#list>
      resellerId: userStore.userInfo.resellerId,
      customerId: userStore.userInfo.customerId,
      projectId: userStore.userInfo.projectId,
    }
  })

  if (data.id) {
    nextTick(() => {
      if (isShow) {
        datas.Tips = '${javaTableName} detail'
      } else {
        datas.Tips = 'Edit ${lowerName}'
      }
      detail(data.id)
    })
  }
  const ruleFormRef = ref<FormInstance>()
  const rules = reactive<FormRules>({
<#list entityDefines as define>
    <#if define.nullable == false>
    ${define.name}: [
      {
        required: true,
        message: 'Please input ${define.name}',
        trigger: 'blur'
      }
    ],
    </#if>
</#list>
  })
  const detail = async (id: any) => {
    let params = {
      id: id
    }
    proxy.$api.${lowerName}.detail(params).then((res: any) => {
      datas.submitForm = res.data
    })
  }
  const save = async (formEl: FormInstance | undefined) => {
    if (!formEl) return
    await formEl.validate(valid => {
      if (!valid) return
      datas.loading = true
      let params = {
        ...datas.submitForm
      }
      if (data.id) {
        useConfirm(update, params, $t('lang.common.plzSubmit'))
      } else {
        useConfirm(create, params, $t('lang.common.plzSubmit'))
      }
    })
  }
  const create = (params: any) => {
    proxy.$api.${lowerName}.create(params).then((res: any) => {
      datas.loading = false
      const data = useCallback(res, $t('lang.common.AddSuc') + '!')
      if (data) search()
    })
  }
  const update = (params: any) => {
    proxy.$api.${lowerName}.update(params).then((res: any) => {
      datas.loading = false
      const data = useCallback(res, $t('lang.common.EditSuc') + '!')
      if (data) search()
    })
  }

  const handleClose = () => {
    emit('close')
  }
  const search = () => {
    emit('close')
    emit('success')
  }
  const dialogVisible = ref(true)

  let resellers = $ref([])
  onMounted(() => {
    listReseller()
  })
  const listReseller = async () => {
    let res: any = await proxy.$api.reseller.listByUser();
    if (res.status === 0) {
      resellers = res.data
      if (!data.id && resellers &&resellers.length > 0) {
        datas.submitForm.resellerId = resellers[0].id
      }
    }
  }
</script>

<style scoped lang="less">
  .dialog-footer button:first-child {
    margin-right: 10px;
  }

  :deep(.el-select) {
    width: 100%;
  }

  :deep(.el-tree) {
    width: 100% !important;
  }
</style>
