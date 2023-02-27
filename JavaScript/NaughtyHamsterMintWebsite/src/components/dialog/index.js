import Dialog from "./main.vue";
import { reactive } from "vue";

export default function initDialog() {
  // 弹窗控制
  const dialog = reactive({
    visible: false,
    id: 0,
    title: "",
    parentData: {},
  });
  const showDialog = (options) => {
    if (options.id === undefined) {
      return;
    }
    dialog.id = options.id;
    dialog.visible = true;
    dialog.title = options.title;
    dialog.parentData = options.parentData;
  };
  return {
    Dialog,
    showDialog,
    dialog,
  };
}
