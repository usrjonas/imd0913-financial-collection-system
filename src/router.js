import { createRouter, createWebHistory } from "vue-router";
import Home from "./views/Home.vue";
import About from "./views/About.vue";
import Deposit from "./views/Deposit.vue";
import Owner from "./views/Owner.vue";

const routes = [
  {
    path: "/",
    name: "Home",
    component: Home,
  },
  {
    path: "/about",
    name: "About",
    component: About,
  },
  {
    path: "/deposit",
    name: "Deposit",
    component: Deposit,
  },
  {
    path: "/owner",
    name: "Owner",
    component: Owner,
  },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

export default router;
