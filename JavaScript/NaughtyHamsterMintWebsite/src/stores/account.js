import { ref } from "vue";
import { defineStore } from "pinia";

export const useAccountStore = defineStore("userStore", () => {
  const account = ref(null);
  const setAccount = (id) => {
    account.value = id;
  };

  return { account, setAccount };
});
