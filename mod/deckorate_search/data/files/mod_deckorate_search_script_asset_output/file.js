// search_box.js.coffee
(function(){var e,t,r;t=function(){return $("._search-box").data("searchBox")},$(window).ready(function(){return $("body").on("change",".search-box-form .search-box-select-type",function(){return t().updateType()}),$("body").on("click",".search-box-form ._search-button",function(t){return r()||e(),t.preventDefault()}),$("body").on("submit",".search-box-form",function(r){if(!t().keyword())return r.preventDefault(),e()}),$("body").on("keypress",".search-box-form .search-box-select-type",function(e){if(e.which=13)return $(this).closest("form").submit()}),t().updateType()}),$.extend(decko.searchBox.prototype,{selectedType:function(){return this.form().find("#query_type").val()},typeParams:function(){return{query:{type:this.selectedType()}}},updateType:function(){return this.updateSource(),this.updatePlaceholder(),this.init()},updateSource:function(){return this.config.source=""===this.selectedType()?this.originalpath:this.originalpath+"?"+$.param(this.typeParams())},updatePlaceholder:function(){var e;return e=this.selectedType(),this.box.attr("placeholder","Search for "+(""===e?"companies, data sets, and more...":e))}}),r=function(){var e;return(e=t()).keyword()&&e.form().submit()||!1},e=function(){var e,r,o;return e=""===(o=(r=t()).selectedType())?":search":o,window.location=decko.path(e+"?"+$.param(r.typeParams()))}}).call(this);