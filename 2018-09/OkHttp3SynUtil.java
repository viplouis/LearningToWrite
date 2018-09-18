package com.yunke.amazon.authorization.utils;

import java.io.IOException;
import java.util.Map;
import java.util.concurrent.TimeUnit;

import com.google.gson.Gson;

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
public class OkHttp3SynUtil {

	/**
	 * 同步GET请求
	 * 
	 * @param url
	 * @throws IOException
	 */
	public static String GetAsynchronous(String url, String scope, String refreshToken, String accessToken)
			throws IOException {
		// TODO Auto-generated method stub

		String result = "";
		// 创建OkHttpClient对象
		OkHttpClient okHttpClient = new OkHttpClient.Builder().connectTimeout(10, TimeUnit.SECONDS)
				.writeTimeout(10, TimeUnit.SECONDS).readTimeout(20, TimeUnit.SECONDS).build();

		Request request = new Request.Builder().url(url) // 请求的url
				.get()// 设置请求方式，get()/post() 查看Builder()方法知，在构建时默认设置请求方式为GET
				.addHeader("Amazon-Advertising-API-Scope", scope).addHeader("Authorization", "Bearer " + accessToken)
				.addHeader("Cache-Control", "no-cache").build();

		Response response = okHttpClient.newCall(request).execute();

		if (response.isSuccessful()) {
			System.out.println("response = " + response);
			result = response.body().string();
		}

		return result;
	}

	/**
	 * 同步刷新accessToken
	 * 
	 * @param url
	 * @param map
	 * @throws IOException
	 */
	public static String PostAccessToken(String url, Map<String, Object> map) throws IOException {
		// TODO Auto-generated method stub
		String result = "";
		OkHttpClient okHttpClient = new OkHttpClient.Builder().connectTimeout(10, TimeUnit.SECONDS)
				.writeTimeout(10, TimeUnit.SECONDS).readTimeout(20, TimeUnit.SECONDS).build();

		Gson gson = new Gson();
		String json = gson.toJson(map);

		// MediaType 设置Content-Type 标头中包含的媒体类型值
		RequestBody requestBody = FormBody.create(MediaType.parse("application/json; charset=utf-8"), json);
		Request request = new Request.Builder().url(url) // 请求的url
				.post(requestBody).addHeader("Content-Type", "application/x-www-form-urlencoded")
				.addHeader("Cache-Control", "no-cache").build();

		Response response = okHttpClient.newCall(request).execute();

		if (response.isSuccessful()) {
			System.out.println("response = " + response);
			result = response.body().string();
		}

		return result;
	}

	/**
	 * 同步Post请求,请求参数类型Json
	 * 
	 * @param url
	 * @param scope
	 * @param refreshToken
	 * @param accessToken
	 * @param map
	 * @throws IOException
	 */
	public static void PostAsynchronous(String url, String scope, String refreshToken, String accessToken,
			Map<String, Object> map) throws IOException {
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

		Response response = okHttpClient.newCall(request).execute();

		if (response.isSuccessful()) {
			System.out.println("response = " + response);
			String result = response.body().string();
		}

	}
}
