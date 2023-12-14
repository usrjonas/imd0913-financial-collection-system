import "./assets/main.css";
import "ant-design-vue/dist/reset.css";

import { createApp, reactive } from "vue";
import App from "./App.vue";
import Antd from "ant-design-vue";

const globalState = reactive({
  contract: {},
  account: "",
});

const app = createApp(App);

app.config.globalProperties.$globalState = globalState;

app.use(Antd);
app.mount("#app");
