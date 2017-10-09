class Tomcat < Formula
  desc "Implementation of Java Servlet and JavaServer Pages"
  homepage "https://tomcat.apache.org/"

  stable do
    url "https://www.apache.org/dyn/closer.cgi?path=tomcat/tomcat-8/v8.5.23/bin/apache-tomcat-8.5.23.tar.gz"
    mirror "https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.23/bin/apache-tomcat-8.5.23.tar.gz"
    sha256 "36aace475dd609ee2123eb3674a095ef7d4dcbbfb322cb85c38095d3c1e1dce2"

    depends_on :java => "1.7+"

    resource "fulldocs" do
      url "https://www.apache.org/dyn/closer.cgi?path=/tomcat/tomcat-8/v8.5.23/bin/apache-tomcat-8.5.23-fulldocs.tar.gz"
      mirror "https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.23/bin/apache-tomcat-8.5.23-fulldocs.tar.gz"
      sha256 "dadc2233f2fb2203513419bca7a0012200d99d1c25a06db05ae77d99789e89fd"
    end
  end

  devel do
    url "https://www.apache.org/dyn/closer.cgi?path=/tomcat/tomcat-9/v9.0.1/bin/apache-tomcat-9.0.1.tar.gz"
    mirror "https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.1/bin/apache-tomcat-9.0.1.tar.gz"
    sha256 "976d9aa996fc34d387ef8de87eed79c5f20c0679b76c1a1fcf331eaa7cdf758f"

    depends_on :java => "1.8+"

    resource "fulldocs" do
      url "https://www.apache.org/dyn/closer.cgi?path=/tomcat/tomcat-9/v9.0.1/bin/apache-tomcat-9.0.1-fulldocs.tar.gz"
      mirror "https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.1/bin/apache-tomcat-9.0.1-fulldocs.tar.gz"
      sha256 "b4e04cc298a87a7c4977394f010c89ec89000016c1698d6905572d5babad9a09"
    end
  end

  bottle :unneeded

  option "with-fulldocs", "Install full documentation locally"

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

  def plist; <<-EOS.undent
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
