class Tomcat < Formula
  desc "Implementation of Java Servlet and JavaServer Pages"
  homepage "https://tomcat.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=/tomcat/tomcat-9/v9.0.24/bin/apache-tomcat-9.0.24.tar.gz"
  sha256 "22064138e25f7ab899802804775259a156c06770535b8ce93856beba13dfcf6d"

  bottle :unneeded

  depends_on :java => "1.8+"

  def install
    # Remove Windows scripts
    rm_rf Dir["bin/*.bat"]

    # Install files
    prefix.install %w[NOTICE LICENSE RELEASE-NOTES RUNNING.txt]
    libexec.install Dir["*"]

    (bin/"catalina").write <<~'EOS'
      #!/bin/sh

      export CATALINA_HOME="$(brew --prefix tomcat)/libexec"
      export CATALINA_BASE="${CATALINA_BASE:-$(brew --prefix)/var/tomcat}"

      catalina_init() {
        if [ ! -e "$CATALINA_BASE/conf" ]; then
          mkdir -p "$CATALINA_BASE"
          cp -r "$CATALINA_HOME/conf" "$CATALINA_BASE/"
        fi

        if [ ! -e "$CATALINA_BASE/conf/Catalina/localhost/" ]; then
          mkdir -p "$CATALINA_BASE/conf/Catalina/localhost/"
        fi

        for app in "$CATALINA_HOME/webapps"/*/; do
          app_name=$(basename "$app")
          context_file="$CATALINA_BASE/conf/Catalina/localhost/${app_name/ROOT/tomcat}.xml"

          if [ ! -e "$context_file" ]; then
            if [ -e "$app/META-INF/context.xml" ]; then
              cp "$app/META-INF/context.xml" "$context_file"
              sed -i "s,<Context,<Context docBase=\"\${catalina.home}/webapps/${app_name}\"," "$context_file"
            else
              printf '<?xml version="1.0" encoding="UTF-8"?>\n<Context docBase="${catalina.home}/webapps/%s" />\n' \
                "${app_name}" > "$context_file"
            fi
          fi
        done
      }

      if [ ! -e "$CATALINA_BASE" ]; then
        catalina_init
      fi

      "$CATALINA_HOME/bin/catalina.sh" "$@"
    EOS
  end

  plist_options :manual => "catalina run"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Disabled</key>
        <false/>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/catalina</string>
          <string>run</string>
        </array>
        <key>KeepAlive</key>
        <true/>
      </dict>
    </plist>
  EOS
  end

  test do
    ENV["CATALINA_BASE"] = testpath
    cp_r Dir["#{libexec}/*"], testpath
    rm Dir["#{libexec}/logs/*"]

    pid = fork do
      exec bin/"catalina", "start"
    end
    sleep 3
    begin
      system bin/"catalina", "stop"
    ensure
      Process.wait pid
    end
    assert_predicate testpath/"logs/catalina.out", :exist?
  end
end
