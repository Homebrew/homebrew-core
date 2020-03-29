class Zookeeper < Formula
  desc "Centralized server for distributed coordination of services"
  homepage "https://zookeeper.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=zookeeper/zookeeper-3.5.7/apache-zookeeper-3.5.7.tar.gz"
  mirror "https://archive.apache.org/dist/zookeeper/zookeeper-3.5.7/apache-zookeeper-3.5.7.tar.gz"
  sha256 "7470d30b17cc77be3b58171d820c432bf5181310fbc62e941e2be2745f7300d4"
  head "https://gitbox.apache.org/repos/asf/zookeeper.git"

  bottle do
    cellar :any
    sha256 "1b10a12fdb023016b1ed490033194f4d301a4bba832d4203e897d69d0660703d" => :catalina
    sha256 "1db0f0b70043d093a975037020e395b7e0c9d8801234a95c02c34670a430a7a6" => :mojave
    sha256 "da26560dd346476ebfa0e5bd7148020ce71053aeeb6a65b0b60e4307844e5574" => :high_sierra
  end

  depends_on "ant" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  def shim_script(target)
    <<~EOS
      #!/usr/bin/env bash
      . "#{etc}/zookeeper/defaults"
      cd "#{libexec}/bin"
      ./#{target} "$@"
    EOS
  end

  def default_zk_env
    <<~EOS
      [ -z "$ZOOCFGDIR" ] && export ZOOCFGDIR="#{etc}/zookeeper"
    EOS
  end

  def default_log4j_properties
    <<~EOS
      log4j.rootCategory=WARN, zklog
      log4j.appender.zklog = org.apache.log4j.RollingFileAppender
      log4j.appender.zklog.File = #{var}/log/zookeeper/zookeeper.log
      log4j.appender.zklog.Append = true
      log4j.appender.zklog.layout = org.apache.log4j.PatternLayout
      log4j.appender.zklog.layout.ConversionPattern = %d{yyyy-MM-dd HH:mm:ss} %c{1} [%p] %m%n
    EOS
  end

  def install
    system "ant", "compile_jute"

    cd "zookeeper-client/zookeeper-client-c" do
      system "autoreconf", "-fiv"
      system "./configure", "--disable-dependency-tracking",
                            "--prefix=#{prefix}",
                            "--without-cppunit"
      system "make", "install"
    end

    rm_f Dir["bin/*.cmd"]

    system "ant"
    libexec.install "bin", "build/lib", "zookeeper-contrib"
    libexec.install Dir["build/*.jar"]

    bin.mkpath
    (etc/"zookeeper").mkpath
    (var/"log/zookeeper").mkpath
    (var/"run/zookeeper/data").mkpath

    Pathname.glob("#{libexec}/bin/*.sh") do |path|
      next if path == libexec+"bin/zkEnv.sh"

      script_name = path.basename
      bin_name    = path.basename ".sh"
      (bin+bin_name).write shim_script(script_name)
    end

    defaults = etc/"zookeeper/defaults"
    defaults.write(default_zk_env) unless defaults.exist?

    log4j_properties = etc/"zookeeper/log4j.properties"
    log4j_properties.write(default_log4j_properties) unless log4j_properties.exist?

    inreplace "conf/zoo_sample.cfg",
              /^dataDir=.*/, "dataDir=#{var}/run/zookeeper/data"
    cp "conf/zoo_sample.cfg", "conf/zoo.cfg"
    (etc/"zookeeper").install ["conf/zoo.cfg", "conf/zoo_sample.cfg"]
  end

  plist_options :manual => "zkServer start"

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
