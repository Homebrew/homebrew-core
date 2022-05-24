class Zookeeper < Formula
  desc "Centralized server for distributed coordination of services"
  homepage "https://zookeeper.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=zookeeper/zookeeper-3.7.0/apache-zookeeper-3.7.0.tar.gz"
  mirror "https://archive.apache.org/dist/zookeeper/zookeeper-3.7.0/apache-zookeeper-3.7.0.tar.gz"
  sha256 "cb3980f61b66babe550dcb717c940160ba813512c0aca26c2b8a718fac5d465d"
  license "Apache-2.0"
  revision 1
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

    (pkgshare/"examples").install "conf/log4j.properties", "conf/zoo_sample.cfg"
  end

  def post_install
    defaults = etc/"zookeeper/defaults"
    defaults.write(default_zk_env) unless defaults.exist?

    log4j_properties = etc/"zookeeper/log4j.properties"
    log4j_properties.write(default_log4j_properties) unless log4j_properties.exist?
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
