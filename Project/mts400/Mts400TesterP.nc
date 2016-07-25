
#include "DataMsg.h"

module Mts400TesterP {
	uses interface Boot;
	uses interface Leds;
	uses interface SplitControl;
	uses interface Read<uint16_t> as X_Axis;
	uses interface Read<uint16_t> as Y_Axis;
	uses interface Intersema;
	uses interface Read<uint16_t> as Temperature;
	uses interface Read<uint16_t> as Humidity;
	uses interface Read<uint8_t> as VisibleLight;
	uses interface Read<uint8_t> as InfraredLight;
	uses interface AMSend;
}
implementation {
	
	uint16_t AccelX_data,AccelY_data,Temp_data,Hum_data,VisLight_data;
	int16_t Intersema_data[2];
	
	event void Boot.booted() {
		call SplitControl.start();
	}
	
	event void SplitControl.startDone(error_t err){
		if(err==SUCCESS){
			call X_Axis.read();
			call Leds.led0On();
		}else{
			call SplitControl.start();
		}
	}
	
	event void X_Axis.readDone(error_t err, uint16_t data){
		AccelX_data=data;
		call Y_Axis.read();
	}
	
	event void Y_Axis.readDone(error_t err, uint16_t data){
		AccelY_data=data;
		call Intersema.read();
	}
	
	event void Intersema.readDone(error_t err, int16_t* data){
		Intersema_data[0]=data[0];
		Intersema_data[1]=data[1];
		call Temperature.read();
	}
	
	event void Temperature.readDone(error_t err, uint16_t data){
		Temp_data=data;
		call Humidity.read();
	}
	
	event void Humidity.readDone(error_t err, uint16_t data){
		Hum_data=data;
		call VisibleLight.read();
	}
	
	event void VisibleLight.readDone(error_t err, uint8_t data){
		VisLight_data=data;
                if(VisLight_data < 30)
		{
			call Leds.led2Off();
                }
		else
		{
			call Leds.led0On();
		}

		call InfraredLight.read();
	}
	
	message_t message;
	
	event void InfraredLight.readDone(error_t err, uint8_t data){
		datamsg_t* packet = (datamsg_t*)(call AMSend.getPayload(&message, sizeof(datamsg_t)));
		packet-> AccelX_data=AccelX_data;
		packet-> AccelY_data = AccelY_data;
		packet-> Intersema_data[0] = Intersema_data[0];
		packet-> Intersema_data[1] = Intersema_data[1];
		packet-> Temp_data =Temp_data;
		packet-> Hum_data = Hum_data;
		packet-> VisLight_data = VisLight_data;
		packet-> InfLight_data = data;
		packet-> member_TOS_NODE_ID = TOS_NODE_ID;

		call AMSend.send(AM_BROADCAST_ADDR, &message, sizeof(datamsg_t));
	}

	event void AMSend.sendDone(message_t* bufPtr, error_t error){
		call X_Axis.read();
		call Leds.led1Toggle();
	}
	
	event void SplitControl.stopDone(error_t err){}
}
