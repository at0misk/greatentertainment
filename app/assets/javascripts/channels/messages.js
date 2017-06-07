App.messages = App.cable.subscriptions.create('MessagesChannel', {  
  received: function(data) {
    $("#messages" + data.topic_id).removeClass('hidden')
		$('#messages' + data.topic_id).stop().animate({
				  scrollTop: $('#messages' + data.topic_id)[0].scrollHeight
				}, 800);
    return $('#messages' + data.topic_id).append(this.renderMessage(data));
  },

  renderMessage: function(data) {
  	$('#chatBox' + data.user_id).val('');
		$('#messages' + data.topic_id).stop().animate({
		  scrollTop: $('#messages' + data.topic_id)[0].scrollHeight
		}, 800);
    return "<p> <b>" + data.username + ": </b>" + data.message + "</p>";
  }

});