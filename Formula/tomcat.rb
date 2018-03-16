class Tomcat < Formula
  desc "Implementation of Java Servlet and JavaServer Pages"
  homepage "https://tomcat.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=/tomcat/tomcat-9/v9.0.6/bin/apache-tomcat-9.0.6.tar.gz"
  sha256 "e35ed35f6f2e5fd1094b7ec5899f3e25a82029cca22f9768a293eaf67f60473f"

  bottle :unneeded

  option "with-fulldocs", "Install full documentation locally"

  depends_on :java => "1.8+"

  resource "fulldocs" do
    url "https://www.apache.org/dyn/closer.cgi?path=/tomcat/tomcat-9/v9.0.6/bin/apache-tomcat-9.0.6-fulldocs.tar.gz"
    sha256 "261a79e19a92d73e97b8995f15aa59c0a9724a871e82bb186fa4d15c958084aa"
  end

  def install
    # Remove Windows scripts
    rm_rf Dir["bin/*.bat"]

    # Install files
    prefix.install %w[NOTICE LICENSE RELEASE-NOTES RUNNING.txt]
    libexec.install Dir["*"]
    bin.install_symlink "#{libexec}/bin/catalina.sh" => "catalina"

    (pkgshare/"fulldocs").install resource("fulldocs") if build.with? "fulldocs"
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
