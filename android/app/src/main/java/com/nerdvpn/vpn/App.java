package com.nerdvpn.vpn;

import android.content.Context;

import androidx.multidex.MultiDex;

public class App extends android.app.Application {
    @Override
    protected void attachBaseContext(Context base) {
        MultiDex.install(this);
        super.attachBaseContext(base);
    }
}
