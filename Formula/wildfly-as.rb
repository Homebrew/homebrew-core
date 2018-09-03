class WildflyAs < Formula
  desc "Managed application runtime for building applications"
  homepage "http://wildfly.org/"
  url "https://download.jboss.org/wildfly/14.0.0.Final/wildfly-14.0.0.Final.tar.gz"
  sha256 "5fdd1f8d8d3a1c7ab76b0cd7b0d4e1d8dc2bb8e38e82d4ed1f08f8d018aa511a"

  bottle :unneeded

  depends_on :java => "1.8+"

  def install
    rm_f Dir["bin/*.bat"]
    rm_f Dir["bin/*.ps1"]
    libexec.install Dir["*"]
    mkdir_p libexec/"standalone/log"
  end

  def caveats; <<~EOS
    The home of WildFly Application Server #{version} is:
      #{opt_libexec}
    You may want to add the following to your .bash_profile:
      export JBOSS_HOME=#{opt_libexec}
      export PATH=${PATH}:${JBOSS_HOME}/bin
  EOS
  end

  plist_options :manual => "#{HOMEBREW_PREFIX}/opt/wildfly-as/libexec/bin/standalone.sh --server-config=standalone.xml"

  def plist; <<~EOS
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
  end
end
