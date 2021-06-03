package com.czf.utils;

public class SystemContext {


    private static ThreadLocal<String> realPath = new ThreadLocal<String>();

    public static String getRealPath() {
        return realPath.get();
    }

    public static void setRealPath(String realPath) {
        SystemContext.realPath.set(realPath);
    }
}
