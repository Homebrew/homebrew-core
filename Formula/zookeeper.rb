class Zookeeper < Formula
  desc "Centralized server for distributed coordination of services"
  homepage "https://zookeeper.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=zookeeper/zookeeper-3.8.0/apache-zookeeper-3.8.0.tar.gz"
  mirror "https://archive.apache.org/dist/zookeeper/zookeeper-3.8.0/apache-zookeeper-3.8.0.tar.gz"
  sha256 "b0c5684640bea2d8bd6610b47ff41be2aefd6c910ba48fcad5949bd2bf2fa1ac"
  license "Apache-2.0"
  head "https://gitbox.apache.org/repos/asf/zookeeper.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "719a25b16ac0045b32a2d185b2f0f028eb820dedbdb88b6363da68516aac7706"
    sha256 cellar: :any,                 arm64_big_sur:  "728afb970486c80614db060a47caf5a1e3b5786988ed1e341ff0dd5ee270e0c8"
    sha256 cellar: :any,                 monterey:       "6345ff0c91566327755a61dd9bc5aa77ea76a41e40803e4d51c6798ba2f8dbfc"
    sha256 cellar: :any,                 big_sur:        "7a09b012f9b2e0c6dde46dfebf2f66846ab86e154087310b99198572d4a37321"
    sha256 cellar: :any,                 catalina:       "d48b7491b18e95751276fd57f4a3ffdf837f174dc43ae537da6f32f4d67d96d4"
    sha256 cellar: :any,                 mojave:         "edf3e23f9959c9b8dbd0e4ddea4e659a3cfc32737d5e57b0333f60a2e47d51da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dcc5154ebfb3479ec0762842b789dab164c7278ca8376264bdedcb6345b5b2c5"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cppunit" => :build
  depends_on "libtool" => :build
  depends_on "maven" => :build
  depends_on "pkg-config" => :build

  depends_on "openjdk"
  depends_on "openssl@1.1"

  def default_zk_env
    <<~EOS
      [ -z "$ZOOCFGDIR" ] && export ZOOCFGDIR="#{etc}/zookeeper"
    EOS
  end

  def default_logback_xml
    <<~EOS
      <configuration>
        <property name="zookeeper.log.dir" value="#{var}/log/zookeeper" />
        <property name="zookeeper.log.file" value="zookeeper.log" />
        <property name="zookeeper.log.threshold" value="INFO" />
        <property name="zookeeper.log.maxfilesize" value="256MB" />
        <property name="zookeeper.log.maxbackupindex" value="20" />

        <appender name="ROLLINGFILE" class="ch.qos.logback.core.rolling.RollingFileAppender">
          <File>${zookeeper.log.dir}/${zookeeper.log.file}</File>
          <encoder>
            <pattern>%d{ISO8601} [myid:%X{myid}] - %-5p [%t:%C{1}@%L] - %m%n</pattern>
          </encoder>
          <filter class="ch.qos.logback.classic.filter.ThresholdFilter">
            <level>${zookeeper.log.threshold}</level>
          </filter>
          <rollingPolicy class="ch.qos.logback.core.rolling.FixedWindowRollingPolicy">
            <maxIndex>${zookeeper.log.maxbackupindex}</maxIndex>
            <FileNamePattern>${zookeeper.log.dir}/${zookeeper.log.file}.%i</FileNamePattern>
          </rollingPolicy>
          <triggeringPolicy class="ch.qos.logback.core.rolling.SizeBasedTriggeringPolicy">
            <MaxFileSize>${zookeeper.log.maxfilesize}</MaxFileSize>
          </triggeringPolicy>
        </appender-->

        <root level="INFO">
          <appender-ref ref="FILE" />
        </root>
      </configuration>
    EOS
  end

  def install
    system "mvn", "install", "-Pfull-build", "-DskipTests"

    system "tar", "-xf", "zookeeper-assembly/target/apache-zookeeper-#{version}-bin.tar.gz"
    binpfx = "apache-zookeeper-#{version}-bin"
    libexec.install binpfx+"/bin", binpfx+"/lib", "zookeeper-contrib"
    rm_f Dir["build-bin/bin/*.cmd"]

    system "tar", "-xf", "zookeeper-assembly/target/apache-zookeeper-#{version}-lib.tar.gz"
    libpfx = "apache-zookeeper-#{version}-lib"
    include.install Dir[libpfx+"/usr/include/*"]
    lib.install Dir[libpfx+"/usr/lib/*"]

    bin.mkpath
    (etc/"zookeeper").mkpath
    (var/"log/zookeeper").mkpath
    (var/"run/zookeeper/data").mkpath

    Pathname.glob("#{libexec}/bin/*.sh") do |path|
      next if path == libexec+"bin/zkEnv.sh"

      script_name = path.basename
      bin_name    = path.basename ".sh"
      (bin+bin_name).write <<~EOS
        #!/bin/bash
        export JAVA_HOME="${JAVA_HOME:-#{Formula["openjdk"].opt_prefix}}"
        . "#{etc}/zookeeper/defaults"
        exec "#{libexec}/bin/#{script_name}" "$@"
      EOS
    end

    cp "conf/zoo_sample.cfg", "conf/zoo.cfg"
    inreplace "conf/zoo.cfg",
              /^dataDir=.*/, "dataDir=#{var}/run/zookeeper/data"
    (etc/"zookeeper").install "conf/zoo.cfg"

    (pkgshare/"examples").install "conf/logback.xml", "conf/zoo_sample.cfg"
  end

  def post_install
    defaults = etc/"zookeeper/defaults"
    defaults.write(default_zk_env) unless defaults.exist?

    logback_xml = etc/"zookeeper/logback.xml"
    logback_xml.write(default_logback_xml) unless logback_xml.exist?
  end

  plist_options manual: "zkServer start"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>EnvironmentVariables</key>
          <dict>
             <key>SERVER_JVMFLAGS</key>
             <string>-Dapple.awt.UIElement=true</string>
          </dict>
          <key>KeepAlive</key>
          <dict>
            <key>SuccessfulExit</key>
            <false/>
          </dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/zkServer</string>
            <string>start-foreground</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
          <key>WorkingDirectory</key>
          <string>#{var}</string>
        </dict>
      </plist>
    EOS
  end

  test do
    output = shell_output("#{bin}/zkServer -h 2>&1")
    assert_match "Using config: #{etc}/zookeeper/zoo.cfg", output
  end
end
