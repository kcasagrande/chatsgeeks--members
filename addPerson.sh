#!/usr/bin/env sh

options=$(getopt --options f:l:n:p:e:i: --longoptions first-name:,last-name:,nickname:,phone:,email:,interest: -- "$@")
eval set -- "$options"

while true; do
	case "${1}" in
		-f|--first-name)
			argFirstName="${2}"
			shift 2
		;;
		-l|--last-name)
			argLastName="${2}"
			shift 2
		;;
		-n|--nickname)
			argNickname="${2}"
			shift 2
		;;
		-p|--phone)
			argPhone="${2}"
			shift 2
		;;
		-e|--email)
			argEmail="${2}"
			shift 2
		;;
		-i|--interest)
			argInterest="${2}"
			shift 2
		;;
		--)
			shift
			break
		;;
		*)
			break
		;;
	esac
done

DATABASE="${1}"
firstName="'${argFirstName:?}'"
lastName="'${argLastName:?}'"
nickname="${argNickname:+'}${argNickname:-NULL}${argNickname:+'}"
phone="${argPhone:+'}${argPhone:-NULL}${argPhone:+'}"
email="${argEmail:+'}${argEmail:-NULL}${argEmail:+'}"
board=$(echo "${argInterest}" | grep --ignore-case --count '[bp]')
cards=$(echo "${argInterest}" | grep --ignore-case --count 'c')
rpg=$(echo "${argInterest}" | grep --ignore-case --count 'r')
videogames=$(echo "${argInterest}" | grep --ignore-case --count 'v')
wargames=$(echo "${argInterest}" | grep --ignore-case --count '[wf]')
social=$(echo "${argInterest}" | grep --ignore-case --count 's')

sqlite3 "${DATABASE}" <<- END
	.echo on
	.parameter set :firstName "${firstName}"
	.parameter set :lastName "${lastName}"
	.parameter set :nickname "${nickname}"
	.parameter set :phone "${phone}"
	.parameter set :email "${email}"
	.parameter set :board "${board}"
	.parameter set :cards "${cards}"
	.parameter set :rpg "${rpg}"
	.parameter set :videogames "${videogames}"
	.parameter set :wargames "${wargames}"
	.parameter set :social "${social}"

	INSERT INTO \`person\`(
		\`id\`,
		\`firstName\`,
		\`lastName\`,
		\`nickName\`,
		\`phone\`,
		\`email\`,
		\`board\`,
		\`cards\`,
		\`rpg\`,
		\`videogames\`,
		\`wargames\`,
		\`social\`,
		\`death\`
	) VALUES (
		RANDOMBLOB(16),
		:firstName,
		:lastName,
		:nickname,
		:phone,
		:email,
		:board,
		:cards,
		:rpg,
		:videogames,
		:wargames,
		:social,
		NULL
	);
END
