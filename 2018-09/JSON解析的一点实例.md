//	    	Gson gson = new Gson();
	    	Token token = new Gson().fromJson(tokenJson, Token.class); 
	    	System.out.println("***** "+token.getRefresh_token());
	    	//Json的解析类对象
//		    JsonParser parser = new JsonParser();
		    //将JSON的String 转成一个JsonArray对象
//	    	JsonArray jsonArray = parser.parse(tokenJson).getAsJsonArray();
//			List<String> stringList = gson.fromJson(jsonArray, new TypeToken<List<String>>() {}.getType());
			
//			System.out.println("stringList = "+stringList);