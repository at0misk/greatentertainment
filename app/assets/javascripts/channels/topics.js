App.topics = App.cable.subscriptions.create('TopicsChannel', {  
  received: function(data) {
  	$("#req_table" + data.user_id).removeClass('hide');
  	$(".topicsList" + data.user_id).append(this.renderTopic(data))
  	$(".topicsListEmpty" + data.user_id).addClass('hide');
  	$(".chatTableHeader" + data.user_id).removeClass('hide');
    return $(".topics" + data.user_id).append(this.renderTopic(data));
  },

  renderTopic: function(data) {
    return  "<tr><td><a href='/topics/" + data.id + "'>" + data.name + '</a></td><td>' + data.request_name + '</td><td>' + data.time + '</td></tr>';
  }

});