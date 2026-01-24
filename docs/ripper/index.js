let db=[];

function ext(fn){
    return fn.split('.').pop();
}

function processContent(content){
    const lines=content.split("\n");
    const root=[];
    const stack=[];

    let currentLevel=0
    for (let line of lines){
        line=line.replace(/\r$/, "");
        const match=line.match(/^(#{1,6})\s+(.*)$/);
        if (match){
            // header
            const level=match[1].length;
            const text=match[2].trim();
            const node={
                level:level,
                text:text,
                content:[],
                children:[]
            }

            while (stack.length && stack[stack.length-1].level>=level) {
                stack.pop();
            }
            if (stack.length==0){
                root.push(node);
            }else{
                const parent=stack[stack.length-1];
                parent.children.push(node);
            }

            stack.push(node)
        }else{
            //just text
            if (stack.length>0){
                stack[stack.length-1].content.push(line)
            }
        }
    }
    return root
}

function cutFirstSegment(path){
    let parts=path.split("/");
    parts=parts.slice(-(parts.length));
    let str="";
    for (let i=1; i<parts.length; i++){
        str=`${str}/${parts[i]}`;
    }
    return str
}

function rip(){
    files=document.getElementById('wiki').files;
    db=[];
    let pending=0;
    for (let i=0; i<files.length; i++){
        let file=files[i];
        if (ext(file.name)=="md"){
            const reader=new FileReader()
            pending++;
            // reader is async
            reader.onload=function(e){
                db.push(
                    {
                        "name":file.name,
                        "path":cutFirstSegment(file.webkitRelativePath),
                        "data":processContent(e.target.result)
                    }
                )
                pending--;
                if (pending==0){
                    downloadFile("db.json",JSON.stringify(db, null, 2));
                }
            };
            reader.readAsText(file);
        }
    }
}

function isArray(arr){
    return (Array.isArray(arr) || (Object.prototype.toString.call(arr) === '[object Object]')) // object Object??
}

// do_not_increment exists incase there's edge cases, unsure what they could be
// stuff with tomfoolery setting arrays/dicts?
// 
// defaults as false, would just +1 to the index to not be 0-indexed bc lua

function pod(dict,do_not_increment){
    let res="";
    if (isArray(dict)){
        for (var key in dict){
            const value=dict[key]
            let pkey=key;
            let pvalue=pod(value,do_not_increment);
            if (!isNaN(Number(pkey))){
                if (!do_not_increment){
                    pkey=Number(pkey)+1;
                }
                pkey=`[${pkey}]`;
            }
            if (pvalue!="nil"){
                res+=`${pkey}=${pvalue},`
            }
        }
        res=res.substring(0,res.length-1); //remove last ,
        return `{${res}}`;
    }else{
        let value=dict;
        let pvalue=dict;
        if (typeof value=="string"){
            // escape stuff
            pvalue=pvalue.replaceAll(`\\`,`\\\\"`);
            pvalue=pvalue.replaceAll(`"`,`\\"`);
            return `"${pvalue}"`;
        } else if (!(value==null || isNaN(value))) {
            return String(pvalue);
        } else {
            return "nil"
        }
    }
}

/*
let arr=[2,3,4,"a",false];
let dict={
    "number": 2,
    "bool": true,
    "apple": "apple!\"",
    "table":[
        "hello",
        "applesauce",
        2,
        true,
        [1,2],
        {
            "strng": "hhello world"
        }
    ]
};
console.log(arr);
console.log(dictionaryToPod(arr));
console.log(dict);
console.log(dictionaryToPod(dict));
*/


// -1 header level == don't check header level
// "" header == don't check header text
function cutSection(processed,header,headerLevel,type){
    let data=[]; //multiple headers
    let toprocess=structuredClone(processed);
    /*
    for (let i=0; i<toprocess.length; i++){
        if (headerLevel==-1 || (toprocess[i].level==headerLevel)){
            if (header=="" || toprocess[i].text==header){
                if (type=="text"){
                    data.push(toprocess[i].text);
                }else{
                    data.push(toprocess[i].content);
                }
                toprocess.push(toprocess[i].children);
            }
        }
    }
    */
    while (toprocess.length>0){
        let obj=toprocess.shift();
        if (headerLevel==-1 || (obj.level==headerLevel)){
            if (header=="" || obj.text==header){
                if (type=="text"){
                    data.push(obj.text);
                }else{
                    console.log(obj.content);
                    data.push(obj.content);
                }
            }
        }
        for (var key in obj.children){
            toprocess.push(obj.children[key]);
        }
    }
    return data;
}

function cutMini(processed){
    let titles=cutSection(processed,"",1,"text");
    let overviews=cutSection(processed,"Overview",-1);
    let db=[];

    for (let i=0; i<titles.length; i++){
        let arr={}
        arr["title"]=titles[i];
        arr["overview"]=overviews[i];
        db.push(arr);
    }

    return db;
}

function downloadFile(filename,str){
    const link=document.createElement("a");
    const file=new Blob([str],{type:"text/plain"});
    link.href=URL.createObjectURL(file);
    link.download=filename;
    link.click();
    URL.revokeObjectURL(link.href);
}

function ripToPod(){
    files=document.getElementById('wiki').files;
    fulldb=[];
    minidb=[];//titles & overview
    let pending=0;
    for (let i=0; i<files.length; i++){
        let file=files[i];
        if (ext(file.name)=="md"){
            const reader=new FileReader()
            pending++;
            // reader is async
            reader.onload=function(e){
                const processed=processContent(e.target.result);
                fulldb.push(
                    {
                        "name":file.name,
                        "path":cutFirstSegment(file.webkitRelativePath),
                        "data":processed
                    }
                )
                minidb.push(
                    {
                        "name":file.name,
                        "path":cutFirstSegment(file.webkitRelativePath),
                        "data":cutMini(processed)
                    }
                )
                pending--;
                if (pending==0){
                    downloadFile("minidb.pod",pod(minidb));
                    downloadFile("db.pod",pod(fulldb));
                }
            };
            reader.readAsText(file);
        }
    }
}