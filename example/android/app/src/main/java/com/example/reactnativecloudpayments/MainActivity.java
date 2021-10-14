package com.example.reactnativecloudpayments;

import com.facebook.react.ReactActivity;
import android.os.Bundle;
import android.content.Intent;

public class MainActivity extends ReactActivity {

  /**
   * Returns the name of the main component registered from JavaScript. This is used to schedule
   * rendering of the component.
   */
  @Override
  protected String getMainComponentName() {
    return "CloudpaymentsExample";
  }

  @Override
  protected void onCreate(Bundle savedInstanceState) {
      super.onCreate(savedInstanceState);

      if (!isTaskRoot()) {
        final Intent intent = getIntent();
        if (intent.hasCategory(Intent.CATEGORY_LAUNCHER) && Intent.ACTION_MAIN.equals(intent.getAction())) {
            finish();
            return;
        }
    }
  }
}
