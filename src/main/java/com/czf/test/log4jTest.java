package com.czf.test;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public class log4jTest {

    public static Log log = LogFactory.getLog(log4jTest.class);

    public static void main(String[] args) {
        int num = 200;
        log.info("czftest = " + num);
        log.info("czfk = " + num);
        log.info("czfy = " + num);
    }

}
