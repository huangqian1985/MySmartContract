import request from "@/utils/request";

// 重大危险源
export function getTotalSupply() {
  return request({
    url: "/getTotalSupply",
    method: "get",
  });
}
