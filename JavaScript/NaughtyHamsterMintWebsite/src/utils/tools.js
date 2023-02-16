/**
 * @returns new URL
 * @description 返回文件
 */
export function getAssetsFile(url) {
  return new URL(`../assets/${url}`, import.meta.url).href;
}

/**
 * @description 复制文本
 */
export function copyHandle(content) {
  let copy = (e) => {
    e.preventDefault();
    e.clipboardData.setData("text/plain", content);
    alert("复制成功");
    document.removeEventListener("copy", copy);
  };
  document.addEventListener("copy", copy);
  document.execCommand("Copy");
}

/**
 * @returns {Array}
 * @description 检测设备类型
 */
export function getDeviceType() {
  const type = [];
  if (/Android|webOS|iPhone|iPod|BlackBerry/i.test(navigator.userAgent)) {
    type.push("mobile");
  } else {
    type.push("pc");
  }
  if (/Android/i.test(navigator.userAgent)) {
    type.push("android");
  }
  if (/iPhone|iPod/i.test(navigator.userAgent)) {
    type.push("ios");
  }
  return type;
}
