# To include these private lanes, add the following line to your Fastfile:
# import_from_git(url: 'git@github.com:AndrewSB/fastlane.git', path: 'Fastfile')

#########  PUBLIC  #########

lane :bootstrap do
	sh './carthage-bootstrap-if-needed.sh'
end

# Expects a :project, :scheme, and optional :branch (defaults to master)
lane :match_build_number_to_git do |options|
	project = options[:project]
	branch = options[:branch] || 'master'
	build = get_build_number(xcodeproj: project)
	numberOfCommits = `git rev-list --count #{branch}`

	increment_build_number(build_number: numberOfCommits, xcodeproj: project)
end

######  BUILD & DEPLOY  #######

# Expects :project & :scheme
private_lane :build do |options|
	project = options[:project]
	scheme = options[:scheme]

	gym(
		scheme: scheme,
		clean: true,
		include_bitcode: true,
		project: project,
		xcargs: "ARCHIVE=YES" # Used to tell the Fabric run script to upload dSYM file
	)
end

# Expects a :destination (TestFlight/App Store), :project & :scheme
private_lane :itc do |options|
	destination = options[:destination]
	project = options[:project]
	scheme = options[:scheme]

	match(type: 'appstore')

	build(project: project, scheme: scheme)

	case destination
	when "TestFlight"
		pilot
	when "App Store"
		deliver(force: true)
	else
		raise "critical error in Fastfile: Uploading an itc build was attempted without specifying `TestFlight` or the `App Store`. Instead, #{destination} was specified 🤔"
	end
end

########  UTIL  #########

# Expects :project, :scheme, :destination & :channel
# Also expects that your Fastfile has setup slack with an API token
private_lane :post_to_slack do |options|
	project		= options[:project]
	scheme      	= options[:scheme]
	version    	= get_version_number(xcodeproj: project)
	build      	= get_build_number(xcodeproj: project)
	environment 	= scheme.upcase
	destination 	= options[:destination]
	channel		= options[:channel]

	slack(
		message: "<!here|here>: New :ios: *#{version}* (#{build}) running `#{environment}` has been submitted to *#{destination}*  :rocket:",
		channel: channel
	)
end

# expects a :title, :message, optional :app_icon (defaults to fastlane icon) & optional :content_image (defaults to nothing)
private_lane :push_notif do |options|
	fastlane_icon_url = 'https://avatars0.githubusercontent.com/u/11098337?v=3&s=400'

	title		= options[:title]
	message		= options[:message]
	app_icon	= options[:app_icon] || fastlane_icon_url
	content_image	= options[:content_image] || ''

	notification(
		title: title,
		message: message,
		content_image: content_image,
		app_icon: app_icon
	)
end
