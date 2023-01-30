class Zookeeper < Formula
  desc "Centralized server for distributed coordination of services"
  homepage "https://zookeeper.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=zookeeper/zookeeper-3.8.1/apache-zookeeper-3.8.1.tar.gz"
  mirror "https://archive.apache.org/dist/zookeeper/zookeeper-3.8.1/apache-zookeeper-3.8.1.tar.gz"
  sha256 "ccc16850c8ab2553583583234d11c813061b5ea5f3b8ff1d740cde6c1fd1e219"
  license "Apache-2.0"
  head "https://gitbox.apache.org/repos/asf/zookeeper.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "bbf6ce9dccf4d4eb401879a9f36c61e39f27fc330a29b693374e9b374dcaf96b"
    sha256 cellar: :any,                 arm64_monterey: "719a25b16ac0045b32a2d185b2f0f028eb820dedbdb88b6363da68516aac7706"
    sha256 cellar: :any,                 arm64_big_sur:  "728afb970486c80614db060a47caf5a1e3b5786988ed1e341ff0dd5ee270e0c8"
    sha256 cellar: :any,                 ventura:        "0bb1c6e3b0f9fdd953c4120cceb5e27827b861e62b7e27a8891daa4210e39a3b"
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
