Template['header'].onRendered -> (

  # initialize form validation
  this.$('.ui.form')
    .form(
      fields:
        customerName  : 'empty',
        customerEid   : 'empty'
    )
)

Template['header'].events(

  'focus input#customerName': -> (
    formActive = Session.get("formStatus")
    $('.header-wrapper').addClass( "active" )

    if formActive != true
      Meteor.setTimeout(->
        $('#hiddenFormFields').transition('fade up')
      , 600)

    Session.set("formStatus", true)
  ),


  'submit form': (e) -> (
    e.preventDefault()
    console.log("Form: " + e.type)
    customer = e.target.customerName.value
    Meteor.call('createReport', customer, (error, result) -> (
        if error
           console.log(JSON.stringify(error,null,2))
           ###
           $('#createMessage').removeClass('positive')
           $('#createMessage').addClass('negative')
           $("#messageTitle").text("Something went wrong")
           $("#messageBody").html("<b>" + error.reason + "</b>. Please try again.")
           $('#createMessage').removeClass('hidden')
           $('html, body').animate(
             scrollTop: 0, 300)
           ###
        else
           console.log(result)
           ###
           $('form').form('clear')
           $('#createMessage').removeClass('negative')
           $('#createMessage').addClass('positive')
           $("#messageTitle").text("Success!")
           $("#messageBody").html("<b>" + templateName + "</b> was successfully created. Now <b><a href=\"/templates\">let's put it to work</a></b>!")
           $('#createMessage').removeClass('hidden')
           Session.set("items", undefined)
           $('html, body').animate(
             scrollTop: 0, 300)
           ###
    ))
    console.log("Called createReport method: " + customer);
  )

)
