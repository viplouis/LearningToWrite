#异步Post OkHttp3请求

package com.yunke.amazon.authorization.services;

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

public class PostSyc {

	public static void main(String[] args) {
		String scope = "4406898251177968";
		String accessToken = "Atza|IwEBIJDnhxU3dtUPk8QNroHN4sB5vvZoMbykimALDIZ8obPwO24XnJ2Hsmc09CeTLO8p4fJRC6TX-1Mk4ndYHDIeU3bD_ISn80zXciNspJvTyaNcqNaLy_ctMag9cS6Nshl35R4G5gPySYg76KOTaHYW-PUh1r749Sq2C3cxjQWGP_J6fyhC5TnyQqdMuTA4FSM6uWsyQtM2l0DrbaJ-_rQwkvAdczq5isUY5ykYmJxcj1bYVQFz-xwYT6TvqZCXwYppgNLDpfKAyWQt6r4kbEGpxiapZbewW6lIi-ecxojYW3Eo3Gxj-B0jyVGvSNmvARLhi1GgY0_n8WMZ3gXEbXkULybbPWTvq1A4FdVVVAxJFsxvW7sHU-4LxeyfJ9mHyLEcgYRAzURdvwr8InJdXpuoYNgM2xhnI--eAemDr_Af8ADUhmIVi31ZSi_Ao-89_QmTlFmGKjxP6wR32DFM_gRL-2J9KUclQkpEwW9mQTqzg0xXXPsnK54nRGd7k6nVjT23iPuwbv2SBIS65GYHxuWAh9wqbgY3-gShMaLux0FV88ZZDumvfxJVYF3Wq13_CqHscSiRoy-16BhDt9F-jjKYHhFaaRB010hoeUnDXsamzwlQPw";

		OkHttpClient okHttpClient = new OkHttpClient.Builder().connectTimeout(10, TimeUnit.SECONDS)
				.writeTimeout(10, TimeUnit.SECONDS).readTimeout(20, TimeUnit.SECONDS).build();

		Map<String, Object> map = new HashMap<>();
		map.put("campaignType", "sponsoredProducts");
		map.put("segment", "placement");
		map.put("reportDate", "20180820");
		map.put("metrics", "impressions,clicks");

		// 使用Gson 添加 依赖 compile 'com.google.code.gson:gson:2.8.1'
		Gson gson = new Gson();
		// 使用Gson将对象转换为json字符串
		String json = gson.toJson(map);

		// MediaType 设置Content-Type 标头中包含的媒体类型值
		RequestBody requestBody = FormBody.create(MediaType.parse("application/json; charset=utf-8"), json);

		Request request = new Request.Builder().url("https://advertising-api-test.amazon.com/v1/campaigns/report")// 请求的url
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
			}

			@Override
			public void onResponse(Call call, Response response) throws IOException {
				System.out.println(response.body().string());
			}
		});
	}

}

response：{"reportId":"amzn1.clicksAPI.v1.m1.5BA07651.a3f6cee1-39da-4733-b174-447cf6b13011","recordType":"campaign","status":"IN_PROGRESS","statusDetails":"Generating report"}

