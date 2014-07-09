jQuery ->
  $(document).on 'click', ".follow", () ->
    userId = $(this).data().userId
    $.ajax
      type: 'POST'
      dataType: "json"
      url: "/logged/users/follow"
      data: { user: { id: userId } }
      success: (data, textStatus, jqXHR) =>
        $(this).removeClass("follow")
        $(this).removeClass("btn-default")
        $(this).html("Following")
        $(this).addClass("following")
        $(this).addClass("btn-primary")
        alertify.success "Following"
      error: (jqXHR,textStatus,errorThrown ) ->
        alertify.error errorThrown

  $(document).on 'click', ".following", () ->
    userId = $(this).data().userId
    $.ajax
      type: 'DELETE'
      dataType: "json"
      url: "/logged/users/unfollow"
      data: { user: { id: userId } }
      success: (data, textStatus, jqXHR) =>
        $(this).removeClass("following")
        $(this).removeClass("btn-primary")
        $(this).html("Follow")
        $(this).addClass("follow")
        $(this).addClass("btn-default")
        alertify.success "You are not following anymore"
      error: (jqXHR,textStatus,errorThrown ) ->
        alertify.error errorThrown

  $(document).on 'mouseover', ".following", () ->
    $(this).removeClass("btn-primary")
    $(this).addClass("btn-danger")
    $(this).html("Unfollow")

  $(document).on 'mouseleave', ".following", () ->
    $(this).addClass("btn-primary")
    $(this).removeClass("btn-danger")
    $(this).html("Following")

  $(document).on 'mouseleave', ".follow", () ->
    $(this).addClass("btn-default")
    $(this).removeClass("btn-danger")
    $(this).html("Follow")