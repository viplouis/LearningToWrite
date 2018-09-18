package com.yunke.amazon.authorization.utils;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.TimeUnit;

import com.google.gson.Gson;

import okhttp3.Call;
import okhttp3.Callback;
import okhttp3.FormBody;
import okhttp3.MediaType;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;

/**
 * 广告API使用的OkHttp3请求工具类
 * 
 * @author Administrator
 *
 */
public class OkHttp3SycUtil {

	/**
	 * 异步GET请求
	 * @param url
	 */
	public static void GetAsynchronous(String url, String scope, String refreshToken, String accessToken) {
		// TODO Auto-generated method stub
				//创建OkHttpClient对象
		        OkHttpClient okHttpClient  = new OkHttpClient.Builder()
		                .connectTimeout(10, TimeUnit.SECONDS)
		                .writeTimeout(10,TimeUnit.SECONDS)
		                .readTimeout(20, TimeUnit.SECONDS)
		                .build();
		        
				Request request = new Request.Builder().url(url) // 请求的url
		                .get()//设置请求方式，get()/post()  查看Builder()方法知，在构建时默认设置请求方式为GET
		                .addHeader("Amazon-Advertising-API-Scope", scope)
		                .addHeader("Authorization", "Bearer "+accessToken)
		                .addHeader("Cache-Control", "no-cache")
						.build();

		        //创建/Call
		        Call call = okHttpClient.newCall(request);
		        //加入队列 异步操作
		        call.enqueue(new Callback() {
		            //请求错误回调方法
		            @Override
		            public void onFailure(Call call, IOException e) {
		                System.out.println("连接失败");
		            }
		            //异步请求(非主线程)
		            @Override
		            public void onResponse(Call call, Response response) throws IOException {
		                if(response.code()==200) {
		                    System.out.println(response.body().string());
		                }     
		            } 
		        });
	}
	
	/**
	 * 异步刷新accessToken
	 * @param url
	 * @param map
	 */
	public static void PostAccessToken(String url, Map<String, Object> map) {
		// TODO Auto-generated method stub

		OkHttpClient okHttpClient = new OkHttpClient.Builder().connectTimeout(10, TimeUnit.SECONDS)
				.writeTimeout(10, TimeUnit.SECONDS).readTimeout(20, TimeUnit.SECONDS).build();

		Gson gson = new Gson();
		String json = gson.toJson(map);

		// MediaType 设置Content-Type 标头中包含的媒体类型值
		RequestBody requestBody = FormBody.create(MediaType.parse("application/json; charset=utf-8"), json);
		Request request = new Request.Builder().url(url) // 请求的url
				  .post(requestBody)
				  .addHeader("Content-Type", "application/x-www-form-urlencoded")
				  .addHeader("Cache-Control", "no-cache")
				  .build();

		// 创建/Call
		Call call = okHttpClient.newCall(request);
		// 加入队列 异步操作
		call.enqueue(new Callback() {
			// 请求错误回调方法
			@Override
			public void onFailure(Call call, IOException e) {
				System.out.println("连接失败");
			}

			@Override
			public void onResponse(Call call, Response response) throws IOException {
				System.out.println(response.body().string());
			}
		});
	}
	
	/**
	 * 异步Post请求,请求参数类型Json
	 * 
	 * @param url
	 * @param scope
	 * @param refreshToken
	 * @param accessToken
	 * @param map
	 */
	public static void PostAsynchronous(String url, String scope, String refreshToken, String accessToken,
			Map<String, Object> map) {
		// TODO Auto-generated method stub
		OkHttpClient okHttpClient = new OkHttpClient.Builder().connectTimeout(10, TimeUnit.SECONDS)
				.writeTimeout(10, TimeUnit.SECONDS).readTimeout(20, TimeUnit.SECONDS).build();
		Gson gson = new Gson();
		String json = gson.toJson(map);
		// MediaType 设置Content-Type 标头中包含的媒体类型值
		RequestBody requestBody = FormBody.create(MediaType.parse("application/json; charset=utf-8"), json);

		Request request = new Request.Builder().url(url) // 请求的url
				.post(requestBody).addHeader("Amazon-Advertising-API-Scope", scope)
				.addHeader("Content-Type", "application/json").addHeader("Authorization", "Bearer " + accessToken)
				.addHeader("Cache-Control", "no-cache").build();
		// 创建/Call
		Call call = okHttpClient.newCall(request);
		// 加入队列 异步操作
		call.enqueue(new Callback() {
			// 请求错误回调方法
			@Override
			public void onFailure(Call call, IOException e) {
				System.out.println("连接失败");
				/**
				 * 如果是accessToken认证失败,此处应该返回去申请一个新的accessToken,并再次调用此方法
				 */
			}
			@Override
			public void onResponse(Call call, Response response) throws IOException {
				System.out.println(response.body().string());
				String result = response.body().string().toString();
			}
		});
	}
}
