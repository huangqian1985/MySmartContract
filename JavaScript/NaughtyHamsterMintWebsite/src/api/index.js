import request from "@/utils/request"

// 重大危险源
export function getTotalSupply (data) {
  return request({
    url: "/test",
    method: "post",
    data
  })
}