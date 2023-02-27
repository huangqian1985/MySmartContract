import axios from "axios";

/*const errorCode = {
  401: "认证失败，无法访问系统资源",
  403: "当前操作没有权限",
  404: "访问资源不存在",
  default: "系统未知错误，请反馈给管理员",
};*/

axios.defaults.headers["Content-Type"] = "application/json;charset=utf-8";

// 创建axios实例
const service = axios.create({
  // axios中请求配置有baseURL选项，表示请求URL公共部分
  baseURL: import.meta.env.VITE_API_BASE,
  // 超时
  timeout: 1000 * 60,
});

// 响应拦截器
service.interceptors.response.use(
  (res) => {
    // 未设置状态码则默认成功状态
    /*const code = res.data.code || "200";
    // 获取错误信息
    const message = errorCode[code] || res.data.msg || errorCode.default;
    if (code === "203") {
      console.log("登录状态已过期，您可以继续留在该页面，或者重新登录");
    } else if (code !== "200") {
      console.log(message);
      return Promise.reject(new Error(message));
    } else {
      return res.data;
    }*/
    return res.data;
  },
  (error) => {
    console.log(error.message);
    return Promise.reject(error);
  }
);

export default service;
