class TomcatAT9 < Formula
  desc "Implementation of Java Servlet and JavaServer Pages"
  homepage "https://tomcat.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tomcat/tomcat-9/v9.0.50/bin/apache-tomcat-9.0.50.tar.gz"
  mirror "https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.50/bin/apache-tomcat-9.0.50.tar.gz"
  sha256 "f2ca90ca2bb1fd6df852bd04c10a778639f6069de84a210506381a36f6d2f7f9"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8d7d2698ac15c9506737dba8dc02a71a27c8dce8a260ccb37cbaa916f6789296"
  end

  keg_only :versioned_formula

  depends_on "openjdk"

  def install
    # Remove Windows scripts
    rm_rf Dir["bin/*.bat"]

    # Install files
    prefix.install %w[NOTICE LICENSE RELEASE-NOTES RUNNING.txt]
    libexec.install Dir["*"]
    (bin/"catalina").write_env_script "#{libexec}/bin/catalina.sh", JAVA_HOME: Formula["openjdk"].opt_prefix
  end

  plist_options manual: "catalina run"

  def plist
    <<~EOS
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
