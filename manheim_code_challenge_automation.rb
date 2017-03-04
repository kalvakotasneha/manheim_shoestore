##########################################################
##########################################################
# -> Manheim - Automation Engineer - Coding Challenge
# -> Name : Sneha Kalvakota
# -> Date : 03-03-2017
##########################################################
##########################################################
require 'rubygems'
require 'watir'
require 'watir-webdriver'
require 'logger'
require 'date'
require 'time'

webbrowser = "chrome"
url = "http://shoestore-manheim.rhcloud.com"

#Deleting old log
if File.exists?("Automation_Output_Sneha_Kalvakota.txt")
  File.delete("Automation_Output_Sneha_Kalvakota.txt")
end

#Using Log File
$LOG = Logger.new('Automation_Output_Sneha_Kalvakota.txt')
$LOG.info "------------------------------------------------------------------------------------"
$LOG.info "------------------------------------------------------------------------------------"
$LOG.info "             Ruby Automation Assignment - Manheim Shoe Store                    "
$LOG.info "------------------------------------------------------------------------------------"
$LOG.info "------------------------------------------------------------------------------------"
$LOG.info ""
$LOG.info ""

#Instantiate Browser Object
browser=Watir::Browser.new:"#{webbrowser}"
$LOG.info "Opening new #{webbrowser} Browser instance......"
browser.window.maximize
#browser.bring_to_front

#Access Manheim Test Website
browser.goto url

#Wait for Page to load and Validate if page is loaded
browser.wait_until {browser.text_field(:id => 'remind_email_input').exists? }
if browser.text_field(:id => 'remind_email_input').exists?
  $LOG.info "#{url} loaded successfully in #{webbrowser}"
else
  $LOG.error "Failed to load #{url} in #{webbrowser}"
end

# Check each month to insure the link exists
months = ["January","February","March","April","May","June","July","August","September","October","November","December"]
months.each do |i|
  $LOG.info "####################################################################################"
  $LOG.info ""
  if browser.link(:text => "#{i}").exists?
    browser.link(:text => "#{i}").click
    browser.div(:class => 'title').wait_until_present
    $LOG.info "Header URL #{i} exists "
    if browser.div(:class => 'title').h2.text.include? "#{i}"
      headerText=browser.div(:class => 'title').h2.text
      $LOG.info "Header Text is #{headerText}"
      $LOG.info "#{i} Page loaded successfully "
    else
      $LOG.error "Unable to load #{i} Page "
    end
  end

  if browser.ul(:id => "shoe_list").lis.length > 0
    $LOG.info "Shoe List Page loaded successfully for the month of #{i}  "

    browser.ul(:id => "shoe_list").lis.each do |li|
      $LOG.info "------------------------------------------------------------------------------------"
      $LOG.info "------------------------------------------------------------------------------------"

      li_id =  li.id
      strShoeName = browser.element(:xpath => "//*[@id=\"#{li_id}\"]/div/table/tbody/tr[2]/td[2]").text
      # Check Description/Blurb
      strdesc = browser.element(:xpath => "//*[@id=\"#{li_id}\"]/div/table/tbody/tr[4]/td[2]").text
      if browser.element(:xpath => "//*[@id=\"#{li_id}\"]/div/table/tbody/tr[4]/td[2]").exists?
        $LOG.info "Description/Blurb for Month - #{i} & Shoe - #{strShoeName} exists."
        $LOG.info "Description/Blurb for Month - #{i} & Shoe - #{strShoeName} is #{strdesc}"
      else
        $LOG.error "Unable to find Description/Blurb for Month - #{i} & Shoe - #{strShoeName}"
      end

      #check if Price exists
      if browser.element(:xpath => "//*[@id=\"#{li_id}\"]/div/table/tbody/tr[3]/td[2]").exists?
        strPrice = browser.element(:xpath => "//*[@id=\"#{li_id}\"]/div/table/tbody/tr[3]/td[2]").text
        $LOG.info "Price for Month - #{i} & Shoe - #{strShoeName} exists."
        $LOG.info "Price for Month - #{i} & Shoe - #{strShoeName} is #{strPrice}."
      else
        $LOG.error "Unable to find Price for Month - #{i} & Shoe #{strShoeName}"
      end

      #check if Image exists
      if browser.image(:xpath => "//*[@id=\"#{li_id}\"]/div/table/tbody/tr[6]/td/img").src.length > 0
        imgsrc = browser.image(:xpath => "//*[@id=\"#{li_id}\"]/div/table/tbody/tr[6]/td/img").src
        $LOG.info "Image source of #{strShoeName} is - #{imgsrc}"
        $LOG.info "Image for Month - #{i} & Shoe - #{strShoeName} exists."
      else
        $LOG.error "Unable to find Image for Month - #{i} & Shoe - #{strShoeName}"
      end
    end
  else
    $LOG.error "Shoe List Page not found for the month of #{i} "
  end
  $LOG.info ""
end

#Validating Email text field and Confirmation message
strEmail="test@gmail.com"
strConfirmationMessage = "Thanks! We will notify you of our new shoes at this email: #{strEmail}"
if browser.text_field(:id => 'remind_email_input').exists?
  $LOG.info "------------------------------------------------------------------------------------"
  $LOG.info "------------------------------------------------------------------------------------"
  $LOG.info "Email Text field is present.."
end
browser.text_field(:id => 'remind_email_input').set strEmail
browser.button(:type => 'submit').click
browser.div(:class => 'flash notice').wait_until_present
if browser.div(:class => 'flash notice').exists?
  if browser.div(:class => 'flash notice').text == strConfirmationMessage
    $LOG.info "Flash notice is visible once email is given and submit button is clicked .."
  else
    $LOG.error "Flash notice not visible, Error, please check"
  end
end
$LOG.info "------------------------------------------------------------------------------------"
$LOG.info "------------------------------------------------------------------------------------"
browser.close

$LOG.info "####################################################################################"
$LOG.info "####################################################################################"


contents = File.read ("Automation_Output_Sneha_Kalvakota.txt")
puts contents