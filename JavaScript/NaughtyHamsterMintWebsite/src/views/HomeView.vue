<template>
  <WebPage v-if="getDeviceType().includes('pc')"></WebPage>
  <MobilePage v-else></MobilePage>
</template>

<script setup>
import WebPage from "./web/WebPage.vue";
import MobilePage from "./mobile/MobilePage.vue";
import { getDeviceType } from "@/utils/tools";

if (
  getDeviceType().includes("mobile") &&
  !window.location.href.includes("/mobile")
) {
  window.location.href = "/mobile/";
}
</script>

<style lang="scss" scoped></style>
