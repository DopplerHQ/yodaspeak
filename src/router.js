import https from 'https'
import cors from 'cors'
import axios from 'axios'
import express from 'express'
import rateLimit from 'express-rate-limit'
import config from './config.js'

const app = express()
const router = express.Router()
const translationLimiter = rateLimit({
    windowMs: 60 * 60 * 1000,
    max: 60,
    handler: (req, res) => {
        res.json({
            text: req.body.text,
            translation: 'Request too many translation, you have. Try in an hour, you must.',
        })
    },
})

router.get('/', (req, res) => {
    res.render('index', {
        translationEndpoint: config.TRANSLATE_ENDPOINT,
        translationSuggestion: config.TRANSLATION_SUGGESTION,
    })
})

router.get('/healthz', (req, res) => {
    res.send('Healthy, this server is.')
})

router.post('/translate', cors(), translationLimiter, (req, res) => {
    console.log(`[info]: tranlsate text "${req.body.text}"`)
    ;(async () => {
        try {
            const response = await axios.post(config.YODA_TRANSLATE_API_ENDPOINT, `text=${req.body.text}`, {
                headers: {
                    'X-Funtranslations-Api-Secret': config.YODA_TRANSLATE_API_KEY,
                },
            })
            res.json({
                text: req.body.text,
                translation: response.data.contents.translated,
            })
        } catch (error) {
            console.log(`[error]: translation failed: ${error.response.data.error.message}`)
            res.status(500).json({ text: req.body.text, error: 'Sorry, am I, as translate your message, I cannot.' })
        }
    })()
})

export default router
