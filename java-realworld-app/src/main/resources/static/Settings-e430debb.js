import{u as e,c as t,i as s,a as i,b as r,d as o,t as l,e as a}from"./index.js";import{L as d}from"./ListErrors-ec82f319.js";const n=l('<div class="settings-page"><div class="container page"><div class="row"><div class="col-md-6 offset-md-3 col-xs-12"><h1 class="text-xs-center">Your Settings</h1><form><fieldset><fieldset class="form-group"><input class="form-control" type="text" placeholder="URL of profile picture"></fieldset><fieldset class="form-group"><input class="form-control form-control-lg" type="text" placeholder="Your Name"></fieldset><fieldset class="form-group"><textarea class="form-control form-control-lg" rows="8" placeholder="Short bio about you"></textarea></fieldset><fieldset class="form-group"><input class="form-control form-control-lg" type="text" placeholder="Email"></fieldset><fieldset class="form-group"><input class="form-control form-control-lg" type="password" placeholder="Password"></fieldset><button class="btn btn-lg btn-primary pull-xs-right" type="submit">Update Settings</button></fieldset></form><hr><button class="btn btn-outline-danger">Or click here to logout.</button></div></div></div></div>');a(["click"]);export default()=>{const[l,{logout:a,updateUser:c}]=e(),[v,u]=t({image:l.currentUser.image||"",username:l.currentUser.username,bio:l.currentUser.bio||"",email:l.currentUser.email,password:""}),f=e=>t=>u(e,t.target.value),g=e=>{e.preventDefault();const t=Object.assign({},v);t.password||delete t.password,t.image||delete t.image,u({updatingUser:!0}),c(t).then((()=>location.hash=`/@${t.username}`)).catch((e=>u({errors:e}))).finally((()=>u({updatingUser:!1})))};return(()=>{const e=n.cloneNode(!0),t=e.firstChild.firstChild.firstChild,l=t.firstChild.nextSibling,c=l.firstChild.firstChild,u=c.firstChild,p=c.nextSibling,m=p.firstChild,$=p.nextSibling,b=$.firstChild,h=$.nextSibling,_=h.firstChild,x=h.nextSibling,U=x.firstChild,C=x.nextSibling,S=l.nextSibling.nextSibling;return s(t,i(d,{get errors(){return v.errors}}),l),l.addEventListener("submit",g),r(u,"change",f("image")),r(m,"change",f("username")),r(b,"change",f("bio")),r(_,"change",f("email")),r(U,"change",f("password")),S.$$click=()=>(a(),location.hash="/"),o((e=>{const t=v.image,s=v.updatingUser,i=v.username,r=v.updatingUser,o=v.bio,l=v.updatingUser,a=v.email,d=v.updatingUser,n=v.password,c=v.updatingUser,f=v.updatingUser;return t!==e._v$&&(u.value=e._v$=t),s!==e._v$2&&(u.disabled=e._v$2=s),i!==e._v$3&&(m.value=e._v$3=i),r!==e._v$4&&(m.disabled=e._v$4=r),o!==e._v$5&&(b.value=e._v$5=o),l!==e._v$6&&(b.disabled=e._v$6=l),a!==e._v$7&&(_.value=e._v$7=a),d!==e._v$8&&(_.disabled=e._v$8=d),n!==e._v$9&&(U.value=e._v$9=n),c!==e._v$10&&(U.disabled=e._v$10=c),f!==e._v$11&&(C.disabled=e._v$11=f),e}),{_v$:void 0,_v$2:void 0,_v$3:void 0,_v$4:void 0,_v$5:void 0,_v$6:void 0,_v$7:void 0,_v$8:void 0,_v$9:void 0,_v$10:void 0,_v$11:void 0}),e})()};
