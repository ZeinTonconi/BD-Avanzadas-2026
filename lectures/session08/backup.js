require('dotenv').config()

const cron = require('cron')
const {exec} = require('child_process')

const job = new cron.CronJob(
	'*/1 * * * *', // cronTime
	function () {
        const user = process.env.USER_DATABASE
        const database = process.env.DATABASE
        const folder = process.env.FOLDER
        const dockerUser = 'postgres'
        const dockeContainer = 'bdavanzada-postgres'
        const currentDate = new Date();
        const fileName = `backup_${currentDate.toISOString().slice(0,10)}.dump`

        const backupCommand = `docker exec -u ${dockerUser} ${dockeContainer} \
        pg_dump -U ${user} -F c -d ${database} -f ${folder}/${fileName}`
        
        const copyCommand = `docker cp ${dockeContainer}:/${folder}/${fileName} ./backups/${fileName}`

        exec(backupCommand, (error, stdout, stderr) => {
            if(error){
                console.error('Error Executing command')
                return;
            }
            exec(copyCommand, (copyError, copyStdout, copyStderr) => {

            }) 
            if(stderr){
                console.error('Error output')
                return;
            }
            console.log('Backup succesful')
        })

	}, // onTick
	true, // start
);

job.start();