<template>
  <teleport to="#app">
  <div class="dialog-box" v-if="modelValue" :style="{width: width, height: height}">
    <div class="dialog-wrap panel-bg">
      <section>
        <div class="dialog-close" @click="hide()"><img src="./images/close.png" alt=""></div>
        <div class="dialog-header" v-if="title !== ''">
          <slot name="header">
            <span class="title">{{ title }}</span>
          </slot>
        </div>
        <div class="dialog-content">
          <slot></slot>
        </div>
      </section>
    </div>
  </div>
  </teleport>
</template>

<script setup>
const props = defineProps({
  modelValue: {
    type: Boolean,
    default: false
  },
  width: {
    type: String,
    default: "400px"
  },
  height: {
    type: String,
    default: "auto"
  },
  title: {
    type: String,
    default: ""
  }
})
const emit = defineEmits(["update:modelValue"])
const hide = () => {
emit("update:modelValue", !props.modelValue)
}
</script>

<style lang="scss" scoped>
.dialog-box {
  position: fixed;
  top:50%;
  left:50%;
  transform: translate(-50%,-50%);
  z-index: 99;
  > .dialog-wrap {
    > section {
      .dialog-close {
        position: absolute;
        right: 20px;
        top: 20px;
        cursor: pointer;
        font-size: 0;
        z-index: 2;
        img {
          width: 34px;
        }
      }
      .dialog-header {
        height: 45px;
        padding-top: 20px;
        padding-left: 35px;
        margin-bottom: 10px;
        font-weight: bold;
        font-size: 16px;

        + .dialog-content {
          height: calc(100% - 55px);
        }
      }
      .dialog-content {
        padding: 50px 20px 20px;
      }
    }
  }
}
</style>
