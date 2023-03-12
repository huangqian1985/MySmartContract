<template>
  <section class="main-content">
    <h3>SORRY</h3>
    <p>{{ text }}</p>
    <div class="button" href="#" @click="emit('hideDialog')">OK</div>
  </section>
</template>

<script setup>
import { computed } from "vue";

const emit = defineEmits(["hideDialog"]);
const props = defineProps({
  parentData: Object,
});

const text = computed(() => {
  return props.parentData.text
    ? props.parentData.text
    : "Only whitelisted users can participate in MINT.";
});
</script>

<style scoped lang="scss">
.main-content {
  text-align: center;
  h3 {
    background: url("@/assets/web/error.png") 0 center no-repeat;
    background-size: 40px 40px;
    display: inline-block;
    padding-left: 60px;
    margin: 0;
    font-size: 36px;
    font-family: MontserratAlternates-BlackItalic;
    font-weight: normal;
  }
  .button {
    background: #000000;
    display: inline-block;
    width: 308px;
    height: 62px;
    line-height: 62px;
    margin: 20px 0 20px;
    font-size: 21px;
    color: #ffffff;
    text-align: center;
    cursor: pointer;
  }
  > p {
    font-size: 21px;
  }
}
</style>
