import { ref } from 'vue'
import { defineStore } from 'pinia'

export const useAccountStore = defineStore('counter', () => {
  const account = ref(null)
  function setAccount(id) {
    account.value = id
  }

  return { account, setAccount }
})
