class WildflyAs < Formula
  desc "Managed application runtime for building applications"
  homepage "https://wildfly.org/"
  url "https://download.jboss.org/wildfly/19.1.0.Final/wildfly-19.1.0.Final.tar.gz"
  sha256 "3e1d7f3d6c4896b1807f9524be66cc937e156601c00cf1a2056ab6e23cc1f3e7"

  bottle :unneeded

  depends_on "openjdk"

  def install
    rm_f Dir["bin/*.bat"]
    rm_f Dir["bin/*.ps1"]

    inreplace "bin/standalone.sh", /JAVA="[^"]*"/, "JAVA='#{Formula["openjdk"].opt_bin}/java'"

    libexec.install Dir["*"]
    mkdir_p libexec/"standalone/log"
  end

  def caveats
    <<~EOS
      The home of WildFly Application Server #{version} is:
        #{opt_libexec}
      You may want to add the following to your .bash_profile:
        export JBOSS_HOME=#{opt_libexec}
        export PATH=${PATH}:${JBOSS_HOME}/bin
    EOS
  end

  plist_options :manual => "#{HOMEBREW_PREFIX}/opt/wildfly-as/libexec/bin/standalone.sh --server-config=standalone.xml"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>KeepAlive</key>
        <dict>
          <key>SuccessfulExit</key>
          <false/>
          <key>Crashed</key>
          <true/>
        </dict>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_libexec}/bin/standalone.sh</string>
          <string>--server-config=standalone.xml</string>
        </array>
        <key>EnvironmentVariables</key>
        <dict>
          <key>JBOSS_HOME</key>
          <string>#{opt_libexec}</string>
          <key>WILDFLY_HOME</key>
          <string>#{opt_libexec}</string>
        </dict>
      </dict>
      </plist>
    EOS
  end

  test do
    ENV["JBOSS_HOME"] = opt_libexec
    system "#{opt_libexec}/bin/standalone.sh --version | grep #{version}"

    port = free_port

    pidfile = testpath/"pidfile"
    ENV["LAUNCH_JBOSS_IN_BACKGROUND"] = "true"
    ENV["JBOSS_PIDFILE"] = pidfile

    mkdir testpath/"standalone"
    mkdir testpath/"standalone/deployments"
    cp_r libexec/"standalone/configuration", testpath/"standalone"
    fork do
      exec opt_libexec/"bin/standalone.sh", "--server-config=standalone.xml",
                                            "-Djboss.http.port=#{port}",
                                            "-Djboss.server.base.dir=#{testpath}/standalone"
    end
    sleep 10

    begin
      system "curl", "-X", "GET", "localhost:#{port}/"
      output = shell_output("curl -s -X GET localhost:#{port}")
      assert_match "Welcome to WildFly", output
    ensure
      Process.kill "SIGTERM", pidfile.read.to_i
    end
  end
end
