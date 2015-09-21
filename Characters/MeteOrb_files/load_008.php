var hasClass=(function(){var reCache={};return function(element,className){return(reCache[className]?reCache[className]:(reCache[className]=new RegExp("(?:\\s|^)"+className+"(?:\\s|$)"))).test(element.className);};})();var autoCollapse=2;var collapseCaption="hide";var expandCaption="show";function collapseTable(tableIndex){var Button=document.getElementById("collapseButton"+tableIndex);var Table=document.getElementById("collapsibleTable"+tableIndex);if(!Table||!Button){return false;}var Rows=Table.rows;if(Button.firstChild.data==collapseCaption){for(var i=1;i<Rows.length;i++){Rows[i].oldDisplayValue=Rows[i].style.display;Rows[i].style.display="none";}Button.firstChild.data=expandCaption;}else{for(var i=1;i<Rows.length;i++){Rows[i].style.display=Rows[i].oldDisplayValue;}Button.firstChild.data=collapseCaption;}}function createCollapseButtons(){var tableIndex=0;var NavigationBoxes=new Object();var Tables=document.getElementsByTagName("table");for(var i=0;i<Tables.length;i++){var parent=
Tables[i].parentNode.parentNode.parentNode.parentNode;if(hasClass(Tables[i],"collapsible")||(hasClass(parent,"navbox")&&hasClass(Tables[i],"navbox"))){var HeaderRow=Tables[i].getElementsByTagName("tr")[0];if(!HeaderRow)continue;var Header=HeaderRow.getElementsByTagName("th")[0];if(!Header)continue;NavigationBoxes[tableIndex]=Tables[i];Tables[i].setAttribute("id","collapsibleTable"+tableIndex);var Button=document.createElement("span");var ButtonLink=document.createElement("a");var ButtonText=document.createTextNode(collapseCaption);Button.className="collapseButton";ButtonLink.style.color=Header.style.color;ButtonLink.setAttribute("id","collapseButton"+tableIndex);ButtonLink.setAttribute("href","javascript:collapseTable("+tableIndex+");");ButtonLink.appendChild(ButtonText);Button.appendChild(document.createTextNode("["));Button.appendChild(ButtonLink);Button.appendChild(document.createTextNode("]"));Header.insertBefore(Button,Header.childNodes[0]);tableIndex++;}}for(var i=0;i<tableIndex;
i++){if(hasClass(NavigationBoxes[i],"collapsed")||(tableIndex>=autoCollapse&&hasClass(NavigationBoxes[i],"autocollapse"))){collapseTable(i);}else if(hasClass(NavigationBoxes[i],"innercollapse")){var element=NavigationBoxes[i];while(element=element.parentNode){if(hasClass(element,"outercollapse")){collapseTable(i);break;}}}}}addOnloadHook(createCollapseButtons);function setCookie(c_name,value,expiredays){var exdate=new Date();exdate.setDate(exdate.getDate()+expiredays);document.cookie=c_name+"="+escape(value)+((expiredays==null)?"":";expires="+exdate.toGMTString());}function getCookie(c_name){if(document.cookie.length>0){c_start=document.cookie.indexOf(c_name+"=");if(c_start!=-1){c_start=c_start+c_name.length+1;c_end=document.cookie.indexOf(";",c_start);if(c_end==-1)c_end=document.cookie.length;return unescape(document.cookie.substring(c_start,c_end));}}return"";}function setStoredValue(key,value,expiredays){if(typeof(localStorage)=="undefined"){setCookie(key,value,expiredays);}else{
localStorage[key]=value;}}function getStoredValue(key,defaultValue){if(typeof(localStorage)=="undefined"){var value=getCookie(key);return value==""?defaultValue:value;}return localStorage[key]==null?defaultValue:localStorage[key];}article="";var tooltipsOn=true;var $tfb;var $ttfb;var $htt;activeHoverLink=null;tipCache={};function hideTip(){$tfb.html("").removeClass("tooltip-ready").addClass("hidden").css("visibility","hidden");if($(this).data('ahl-id')==activeHoverLink)activeHoverLink=null;}function displayTip(e){$htt.not(":empty").removeClass("hidden").addClass("tooltip-ready");moveTip(e);$htt.not(":empty").css("visibility","visible");moveTip(e);}function moveTip(e){$ct=$htt.not(":empty");var newTop=e.clientY+((e.clientY>($(window).height()/2))?-($ct.innerHeight()+20):20);var newLeft=e.clientX+((e.clientX>($(window).width()/2))?-($ct.innerWidth()+20):20);$ct.css({"position":"fixed","top":newTop+"px","left":newLeft+"px"});}function showTipFromCacheEntry(e,url,tag){var h=tipCache[url+
" "+tag];if(!h){h=tipCache[url].find(tag);if(h.length)tipCache[url+" "+tag]=h;}if(!h.length){$tfb.html('<div class="tooltip-content"><b>Error</b><br />This target either has no tooltip<br />or was not intended to have one.</div>');}else{if($.browser.msie)h=h.clone();h.css("display","").addClass("tooltip-content");$tfb.html(h);}displayTip(e);}function showTip(e){var $t=$(this);$p=$t.parent();if($p.hasClass("selflink")==false){var tooltipIdentifier=".tooltip-content",tooltipTag=$t.attr("class").match(/taggedttlink(-[^\s]+)/)
if(tooltipTag)tooltipIdentifier+=tooltipTag[1];var url="/index.php?title="+$t.data("tt").replace(/ /g,"_").replace(/\?/g,"%3F")+"&action=render .tooltip-content";var tipId=url+" "+tooltipIdentifier;activeHoverLink=tipId;$t.data('ahl-id',tipId);if(tipCache[url]!=null)return showTipFromCacheEntry(e,url,tooltipIdentifier);$('<div style="display: none"/>').load(url,function(text){if(text=="")return;tipCache[url]=$(this);if(tipId!=activeHoverLink)return;showTipFromCacheEntry(e,url,tooltipIdentifier);});}}function hideTemplateTip(){$ttfb.html("").removeClass("tooltip-ready").addClass("hidden");}function showTemplateTip(e){$ttfb.html('<div class="tooltip-content">'+$(this).next().html()+'</div>');displayTip(e);}function eLink(db,nm){dbs=new Array("http://us.battle.net/wow/en/search?f=wowitem&q=","http://www.wowhead.com/?search=");dbTs=new Array("Armory","Wowhead");dbHs=new Array("&real; ","&omega; ");el='<a href="'+dbs[db]+nm+'" target="_blank" title="'+dbTs[db]+'">'+dbHs[db]+'</a>';return el
;}function bindTT(){$t=$(this);$p=$t.parent();if($p.hasClass("selflink")==false){$t.data("tt",$p.attr("title").replace(" (page does not exist)","").replace("?","%3F")).hover(showTip,hideTip).mousemove(moveTip);if($p.hasClass("new")){els='<sup><span class="plainlinks">';y=($t.hasClass("itemlink"))?0:1;z=($t.hasClass("achievementlink"))?2:2;for(x=y;x<z;x++)els+=eLink(x,$t.data("tt").replace("Quest:",""));$p.after(els+'</span></sup>');}else{$t.removeAttr("title");$p.removeAttr("title");}}}function ttMouseOver(){if(tooltipsOn&&getCookie("wiki-tiploader")!="no"){$(article).append('<div id="tfb" class="htt"></div><div id="templatetfb" class="htt"></div>');$tfb=$("#tfb");$ttfb=$("#templatetfb");$htt=$("#tfb,#templatetfb");$(".ajaxoutertt > a").wrapInner('<span class="ajaxttlink" />');$(article+" span.ajaxttlink").each(bindTT);$(article+" span.tttemplatelink").hover(showTemplateTip,hideTemplateTip).mousemove(moveTip);}}$(function(){article="#bodyContent";ttMouseOver();});mw.loader.state({
"site":"ready"});
/* cache key: diablo_gamepedia:resourceloader:filter:minify-js:7:adb9d3c126a593c8d3903cabfd14ea94 */