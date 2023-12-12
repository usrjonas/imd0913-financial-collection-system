import { notification } from "ant-design-vue";

export const infoNotification = (title, description) => {
  notification["info"]({
    message: title,
    description: description,
    duration: 5,
    placement: "top",
  });
};

export const successNotification = (title, description) => {
  notification["success"]({
    message: title,
    description: description,
    duration: 5,
    placement: "top",
  });
};

export const errorNotification = (title, description) => {
  notification["error"]({
    message: title,
    description: description,
    duration: 5,
    placement: "top",
  });
};
