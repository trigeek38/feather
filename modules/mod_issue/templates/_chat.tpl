<form>
<input type="text" name="chat" id="chat">
<button>Chat</button>
</form>
<ul id="chat-log">
  <li>{{ msg }}</li>
  <li>{{ m.signal[{new_chat}].props }}</li>
</ul>

