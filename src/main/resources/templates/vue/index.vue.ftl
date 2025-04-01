<template>
  <pro-container>
    <pro-form ref="queryFormRef" v-model="queryForm" :labelWidth="datas.labelWidth" :fields="fields" query @on-query="onQuery" @on-reset="onReset"> </pro-form>
    <pro-table
      ref="proTableRef"
      :toolbars="toolbars"
      :data="data"
      :columns="columns"
      :total="total"
      :selection="true"
      v-model:page-no="pageNo"
      v-model:page-size="pageSize"
      @current-change="onCurrentChange"
      @size-change="onSizeChange"
    >
      <!-- <template #dataStatus="scope">
        {{ scope.row.status == 1 ? 'enabled' : 'disabled' }}
      </template> -->
    </pro-table>
  </pro-container>
  <edit v-if="datas.showEdit" @close="close" :editData="datas.editData" :isShow="datas.show" @success="refresh"> </edit>
</template>

<script setup lang="ts">
  import useTable from '@/hooks/useTable'
  import { useCallback } from '@/hooks/useCallback'
  import { useConfirm } from '@/hooks/useConfirm'
  import { Delete, Plus } from '@element-plus/icons-vue'
  import edit from './edit.vue'
  const { proxy } = getCurrentInstance() as any
  const $t = proxy.$t
  let queryForm = $ref({
    keyword: ''
  })
  let fields = $ref([
    {
      prop: 'keyword',
      label: 'Name',
      component: 'input',
      labelWidth: '0px'
    }
  ])
  interface Datas {
    showEdit: boolean
    editData: any
    show: boolean
  }
  let datas: Datas = reactive({
    showEdit: false,
    editData: {},
    show: false,
    labelWidth: 0
  })
  let proTableRef = $ref(null)
  let toolbars = [
    {
      label: $t('lang.common.add'),
      type: 'primary',
      icon: 'Plus',
      click: () => {
        preCreate()
      }
    }
  ]
  const getTableData = async (params: any) => {
    params = {
      ...params,
      ...queryForm
    }
    let {
      data: { content: data, totalElements: totalCount }
    } = await proxy.$api.${lowerName}.search(params)
    return {
      dataList: data || [],
      totalCount: totalCount
    }
  }
  let { queryFormRef, data, total, onQuery, onReset, pageNo, pageSize, onCurrentChange, onSizeChange, refresh } = useTable({
    getTableData
  })
  let columns = $ref([
<#list entityDefines as define>
  <#if define.name == "status">
    { label: 'Status', prop: 'status', formatter: (row: any) => (row.status == 1 ? 'Frozen' : 'Normal') },
  <#else>
    { label: '${define.name?cap_first}', prop: '${define.name}' },
  </#if>
</#list>
    { label: 'Reseller', prop: 'resellerId', formatter: (row: any) => (resellerMap[row.resellerId] || '-') },
    { label: 'Create time', prop: 'createTime' },
    { label: 'Update time', prop: 'updateTime' },
    {
      label: 'Operation',
      prop: 'option',
      width: '250',
      buttons: [
        {
          label: 'Detail',
          click: ({ row }) => {
            preShow(row)
          }
        },
        {
          label: 'Edit',
          click: ({ row }) => {
            preEdit(row)
          }
        },
        {
          label: 'Delete',
          type: 'danger',
          click: ({ row }) => {
            preDelete(row)
          }
        }
      ]
    }
  ])
  const preDelete = (data: any) => {
    let params = [data.id]
    useConfirm(deleteData, params, 'Delete the selected data?')
  }
  const deleteData = async (params: any) => {
    const res = await proxy?.$api.${lowerName}.delete(params)
    refresh(), useCallback(res, 'Deleted successfully!')
  }
  const close = (data: any) => {
    datas.showEdit = false
  }
  const preCreate = () => {
    datas.show = false
    datas.editData = {}
    datas.showEdit = true
  }
  const preEdit = (data: any) => {
    datas.show = false
    datas.editData = data
    datas.showEdit = true
  }
  const preShow = (data: any) => {
    datas.show = true
    datas.editData = data
    datas.showEdit = true
  }

  const resellerMap = $ref({})
  onMounted(() => {
    listReseller()
  })
  const listReseller = async () => {
    let params = {
      page: 0,
      size: 9999
    }
    let res: any = await proxy.$api.reseller.search(params);
    if (res.status === 0) {
      res.data.content.forEach(item => {
        resellerMap[item.id] = item.name;
      });
    }
  }
</script>
<style lang="less" scoped></style>
