<div class="control-group"> 
      <label class="control-label" for="time_zone">{_ Time Zone _}</label> 
        <div class="controls"> 
        <select name="time_zone"> 
          <option value="0,Eastern Standard Time"> Eastern Standard Time(EST) </option> 
          <option value="-1,Central Standard Time" {% ifequal "-1" m.acl.user.time_zone|element:1 %} selected {% endifequal %}> Central Standard Time(CST) </option> 
          <option value="-2,Mountain Standard Time" {% ifequal "-2" m.acl.user.time_zone|element:1 %} selected {% endifequal %}> Mountain Standard Time(MST) </option> 
          <option value="-3,Pacific Standard Time" {% ifequal "-3" m.acl.user.time_zone|element:1 %} selected {% endifequal %}> Pacific Standard Time(PST) </option> 
        </select> 
        <p class="help-block">Select your Time Zone. Defaults to EST</p> 
      </div> 
    </div>