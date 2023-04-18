class Zookeeper < Formula
  desc "Centralized server for distributed coordination of services"
  homepage "https://zookeeper.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=zookeeper/zookeeper-3.8.1/apache-zookeeper-3.8.1.tar.gz"
  mirror "https://archive.apache.org/dist/zookeeper/zookeeper-3.8.1/apache-zookeeper-3.8.1.tar.gz"
  sha256 "ccc16850c8ab2553583583234d11c813061b5ea5f3b8ff1d740cde6c1fd1e219"
  license "Apache-2.0"
  head "https://gitbox.apache.org/repos/asf/zookeeper.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a8742d575ac53677c5d55b073de3e91ad816b5469b491cb0b646a8ee6c4ff5de"
    sha256 cellar: :any,                 arm64_monterey: "34ebee0822b3104c72785ceb6959e6b240482795beb53eac28c08c57b6643720"
    sha256 cellar: :any,                 arm64_big_sur:  "8ee6d47295020d61cf269965becc1be63a615ec04da3d85edbb5cae68057965b"
    sha256 cellar: :any,                 ventura:        "088436591d872c536d4e26fe95f73d03d107ba073ec0a67132d7673e507cb7b6"
    sha256 cellar: :any,                 monterey:       "c1d656f5fddee17000a42fa67749c2feedac5b3f324cc86ee84f7f5589c09209"
    sha256 cellar: :any,                 big_sur:        "51fe2a40f7b3486dec74be435c21c2ac556db05e4dc22ce7d27f04a192c9f977"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37a902639bd15382b6bbecc179e4244c9db2b07b08e5b0927e9dc304c5a52497"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cppunit" => :build
  depends_on "libtool" => :build
  depends_on "maven" => :build
  depends_on "pkg-config" => :build

  depends_on "openjdk"
  depends_on "openssl@1.1"

  resource "default_logback_xml" do
    url "https://raw.githubusercontent.com/apache/zookeeper/release-3.8.1/conf/logback.xml"
    sha256 "2fae7f51e4f92e8e3536e5f9ac193cb0f4237d194b982bb00b5c8644389c901f"
  end

  def default_zk_env
    <<~EOS
      [ -z "$ZOOCFGDIR" ] && export ZOOCFGDIR="#{etc}/zookeeper"
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
    tmpdir = Pathname.new(Dir.mktmpdir)
    tmpdir.install resource("default_logback_xml")

    defaults = etc/"zookeeper/defaults"
    defaults.write(default_zk_env) unless defaults.exist?

    logback_xml = etc/"zookeeper/logback.xml"
    logback_xml.write(tmpdir/"default_logback_xml") unless logback_xml.exist?
  end

  service do
    run [opt_bin/"zkServer", "start-foreground"]
    environment_variables SERVER_JVMFLAGS: "-Dapple.awt.UIElement=true"
    keep_alive successful_exit: false
    working_dir var
  end

  test do
    output = shell_output("#{bin}/zkServer -h 2>&1")
    assert_match "Using config: #{etc}/zookeeper/zoo.cfg", output
  end
end
