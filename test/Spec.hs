{-# LANGUAGE RankNTypes #-}
module Main where

--import qualified BoostersHeatUpTest as T1

import Andromeda.LogicControl.Language
import Andromeda.Hardware.Language
import Andromeda.Common.Value

import Common

import Prelude hiding (read)
import Control.Monad.Free

fromKelvin :: Measurment Kelvin -> Float
fromKelvin (Measurment (FloatValue v)) = v
fromCelsius :: Measurment Celsius -> Float
fromCelsius (Measurment (FloatValue v)) = v
fromPascal :: Measurment Pascal -> Float
fromPascal (Measurment (FloatValue v)) = v

readTemperature :: Controller -> Script Kelvin Float
readTemperature controller = do
    t <- read controller temperature
    return $ fromKelvin t
    
readPressure :: Controller -> Script Pascal Float
readPressure controller = do
    t <- read controller pressure
    return $ fromPascal t

{-
impossible :: Controller -> Script Celsius Float
impossible controller = do
    t <- read controller temperature
    return $ fromCelsius t
-}

sendTemperature controller = do
    t <- unwrap $ readTemperature controller
    sendData (floatValue t)
    p <- unwrap $ readPressure controller
    sendData (floatValue p)

main :: IO ()
main = do
    print "Testing..."
    --T1.test
    interpreter (sendTemperature boostersController)
    

