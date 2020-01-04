package com.sakadevsinc.sams_flutter_share;

import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.util.Log;

import androidx.core.content.FileProvider;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** SamsFlutterSharePlugin */
public class SamsFlutterSharePlugin implements MethodCallHandler {
  private Registrar _registrar;
  private final String PROVIDER_AUTH_EXT = ".https://github.com/SamNdirangu/sams_flutter_share";


  private SamsFlutterSharePlugin(Registrar registrar) {
      this._registrar = registrar;
  }

  
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "sams_flutter_share");
    channel.setMethodCallHandler(new SamsFlutterSharePlugin(registrar));
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("shareText")) {
      shareText(call.arguments);
    }
    if (call.method.equals("shareFile")) {
        shareFile(call.arguments);
    }
    if (call.method.equals("shareMultipleFiles")) {
      shareMultipleFiles(call.arguments);
    }
  }

  // Share our text
  private void shareText(Object arguments) {
    @SuppressWarnings("unchecked")
    HashMap<String, String> argsMap = (HashMap<String, String>) arguments;
    String shareTitle = argsMap.get("shareTitle");
    String text = argsMap.get("text");
    String mimeType = argsMap.get("mimeType");
    String appToShare = argsMap.get("appToShare");

    Context activeContext = _registrar.activeContext();

    Intent shareIntent = new Intent(Intent.ACTION_SEND);
    shareIntent.setType(mimeType);
    shareIntent.putExtra(Intent.EXTRA_TEXT, text);

    if(!appToShare.isEmpty()){
        shareIntent.setPackage(appToShare);
        try {
            activeContext.startActivity(shareIntent);
        } catch (android.content.ActivityNotFoundException ex) {
            activeContext.startActivity(Intent.createChooser(shareIntent, shareTitle));
        }
    } else {
      activeContext.startActivity(Intent.createChooser(shareIntent, shareTitle));
    }
  }

  //Share our file
  private void shareFile(Object arguments) {
    @SuppressWarnings("unchecked")
    HashMap<String, String> argsMap = (HashMap<String, String>) arguments;
    String shareTitle = argsMap.get("shareTitle");
    String fileName = argsMap.get("fileName");
    String mimeType = argsMap.get("mimeType");
    String captionText = argsMap.get("captionText");
    String appToShare = argsMap.get("appToShare");

    Context activeContext = _registrar.activeContext();

    Intent shareIntent = new Intent(Intent.ACTION_SEND);
    
    shareIntent.setType(mimeType); //Set the mimetype
    File file = new File(activeContext.getCacheDir(), fileName);
    
    String fileProviderAuthority = activeContext.getPackageName() + PROVIDER_AUTH_EXT;
    Uri contentUri = FileProvider.getUriForFile(activeContext, fileProviderAuthority, file);
    shareIntent.putExtra(Intent.EXTRA_STREAM, contentUri);
    
    // add optional caption text
    if (!captionText.isEmpty()) shareIntent.putExtra(Intent.EXTRA_TEXT, captionText);
    
    if(!appToShare.isEmpty()){
      shareIntent.setPackage(appToShare);
      try {
          activeContext.startActivity(shareIntent);
      } catch (android.content.ActivityNotFoundException ex) {
          activeContext.startActivity(Intent.createChooser(shareIntent, shareTitle));
      }
    } else {
      activeContext.startActivity(Intent.createChooser(shareIntent, shareTitle));
    }
  }

  // Share multiple files
  private void shareMultipleFiles(Object arguments) {
    @SuppressWarnings("unchecked")
    HashMap<String, Object> argsMap = (HashMap<String, Object>) arguments;
    String shareTitle = (String) argsMap.get("shareTitle");
    ArrayList<String> fileNames = (ArrayList<String>) argsMap.get("filesBytes");
    String mimeType = (String) argsMap.get("mimeType");
    String captionText = (String) argsMap.get("captionText");
    String appToShare = (String) argsMap.get("appToShare");

    Context activeContext = _registrar.activeContext();

    Intent shareIntent = new Intent(Intent.ACTION_SEND_MULTIPLE);
    shareIntent.setType(mimeType);

    ArrayList<Uri> contentUris = new ArrayList<>();

    for (String fileName : fileNames) {
        File file = new File(activeContext.getCacheDir(), fileName);
        String fileProviderAuthority = activeContext.getPackageName() + PROVIDER_AUTH_EXT;
        contentUris.add(FileProvider.getUriForFile(activeContext, fileProviderAuthority, file));
    }

    shareIntent.putParcelableArrayListExtra(Intent.EXTRA_STREAM, contentUris);
    // add optional text
    if (!captionText.isEmpty()) shareIntent.putExtra(Intent.EXTRA_TEXT, captionText);

    if(!appToShare.isEmpty()){
        shareIntent.setPackage(appToShare);
        try {
            activeContext.startActivity(shareIntent);
        } catch (android.content.ActivityNotFoundException ex) {
            activeContext.startActivity(Intent.createChooser(shareIntent, shareTitle));
        }
    } else {
        activeContext.startActivity(Intent.createChooser(shareIntent, shareTitle));
    }
  }
}
