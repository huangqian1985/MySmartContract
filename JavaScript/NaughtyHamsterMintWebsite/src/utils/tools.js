export function getAssetsFile(url) {
    return new URL(`../assets/${url}`, import.meta.url).href
}

export function copyHandle(content){
    let copy = (e)=>{
        e.preventDefault()
        e.clipboardData.setData('text/plain',content)
        alert('复制成功')
        document.removeEventListener('copy',copy)
    }
    document.addEventListener('copy',copy)
    document.execCommand("Copy");
}