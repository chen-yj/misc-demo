import http from '@/http/index.js'

const api = {
  async request(url, params, type = 'get') {
    let res = await http.request('/${lowerName}' + url, params, type)
    return res
  },
  async search({ pageNo = 1, pageSize = 10, ...params }) {
    return await this.request('/search?page=' + pageNo + '&size=' + pageSize, params)
  },
  async create(params) {
    return await this.request('/create', params, 'post')
  },
  async update(params) {
    return await this.request('/update', params, 'post')
  },
  async detail(params) {
    return await this.request('/detail', params)
  },
  async delete(params) {
    return await this.request('/delete', params, 'del')
  }
}

export default api
