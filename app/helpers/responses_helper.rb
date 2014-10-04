module ResponsesHelper
	def get_written_day(response)
		return "Today" if @todays_date == response.time
		return "Yesterday" if @todays_date.day - response.time.day == 1
		return response.time.to_date.strftime('%d %B')
	end
end
