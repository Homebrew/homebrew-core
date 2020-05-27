class Zookeeper < Formula
  desc "Centralized server for distributed coordination of services"
  homepage "https://zookeeper.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=zookeeper/zookeeper-3.5.8/apache-zookeeper-3.5.8.tar.gz"
  mirror "https://archive.apache.org/dist/zookeeper/zookeeper-3.5.8/apache-zookeeper-3.5.8.tar.gz"
  sha256 "bafc0abe7da696a2020ba11b8ce7d06f6e28e9bf1e5504de09be25b8b589777d"
  head "https://gitbox.apache.org/repos/asf/zookeeper.git"

  bottle do
    cellar :any
    sha256 "e22e36c7f02c5c57703d90d8a594896d0335311fc016130db2716822c750373f" => :catalina
    sha256 "8a108199968e633827d46cc43bebef94bce9fd0f81cf05b1d61c2ad6b41a8fc4" => :mojave
    sha256 "272323746835859d1f1181e79893fc16b0f48ee8ea401b6412fa5266f6439f6d" => :high_sierra
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
