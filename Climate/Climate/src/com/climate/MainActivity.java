package com.climate;


import java.io.IOException;

import org.apache.http.HttpResponse;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.params.BasicHttpParams;
import org.apache.http.params.HttpConnectionParams;
import org.apache.http.params.HttpParams;
import org.apache.http.util.EntityUtils;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.os.Bundle;
import android.os.StrictMode;
import android.app.Activity;
//import android.content.Intent;
import android.view.Menu;
//import android.view.MenuItem;
import android.widget.TextView;


public class MainActivity extends Activity {
	
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        StrictMode.ThreadPolicy policy = new StrictMode.
        		ThreadPolicy.Builder().permitAll().build();
                 StrictMode.setThreadPolicy(policy);
                 
        	TextView temp = (TextView) findViewById(R.id.temp);
            TextView press = (TextView) findViewById(R.id.press);
            TextView humi = (TextView) findViewById(R.id.humi);
            TextView visi = (TextView) findViewById(R.id.visi);
            
              
            JSONObject json = null;
            String str = "";
            HttpResponse response;
          //Create the HTTP request
            HttpParams httpParameters = new BasicHttpParams();
          //Setup timeouts
            HttpConnectionParams.setConnectionTimeout(httpParameters, 8000);
            HttpConnectionParams.setSoTimeout(httpParameters, 8000);	
            HttpClient myClient = new DefaultHttpClient(httpParameters);
            HttpPost myConnection = new HttpPost("http://10.100.188.223/android_connect/climatenode.php");
            
            try {
                response = myClient.execute(myConnection);
                str = EntityUtils.toString(response.getEntity(), "UTF-8");
                 
            } catch (ClientProtocolException e) {
                e.printStackTrace();
            } catch (IOException e) {
                e.printStackTrace();
            }
             
             
            try{
            	JSONArray jArray = new JSONArray(str);
                json = jArray.getJSONObject(0);
                 
                temp.setText(json.getString("Temperature"));
                press.setText(json.getString("Pressure"));
                humi.setText(json.getString("Humidity"));
                visi.setText(json.getString("VisibleLight")); 
                
                
            } catch ( JSONException e) {
                e.printStackTrace();                
            }
              
        	} 
        	
    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.main, menu);
        return true;
    }
    
   }
    