import { createRouter, createWebHistory } from "vue-router";
import HomeView from "../views/HomeView.vue";
import WhiteList from "@/views/web/WhiteList.vue";

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: "/",
      name: "home",
      component: HomeView,
    },
    {
      path: "/white-list",
      name: "whiteList",
      component: WhiteList,
    },
    {
      path: "/:pathMatch(.*)",
      redirect: "/",
    },
  ],
});

export default router;
