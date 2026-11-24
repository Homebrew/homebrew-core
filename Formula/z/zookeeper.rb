class Zookeeper < Formula
  desc "Centralized server for distributed coordination of services"
  homepage "https://zookeeper.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=zookeeper/zookeeper-3.10.0/apache-zookeeper-3.10.0.tar.gz"
  mirror "https://archive.apache.org/dist/zookeeper/zookeeper-3.10.0/apache-zookeeper-3.10.0.tar.gz"
  sha256 "a94a9ccc4f2816ac4ebcf9083da85fd9ddf4dac3422ca2bd79d696bea1a5fbc1"
  license "Apache-2.0"
  compatibility_version 1
  head "https://gitbox.apache.org/repos/asf/zookeeper.git", branch: "master"

  bottle do
    manifest_sha256 "c826fcc62d72e3c3a96ef4013373fe2cb85159557cd39b635fec62808ff51f9a"
    sha256 cellar: :any, arm64_golden_gate: "740a725fbeb3fc73936a6c646b11cac1255770b9fd3018ba536741768881de2d"
    sha256 cellar: :any, arm64_tahoe:       "3c6d6efa9619279e4cd7ed22eb2f7a2c68dc9008eff34de63146771acbc761f7"
    sha256 cellar: :any, arm64_sequoia:     "12489ee4b27e3e8212d94f671c0a8d28e73f7f49ec75b8bb68acc0377d48cd9b"
    sha256 cellar: :any, arm64_linux:       "3b0522256c9229bca55d6640e35cdeaad13291b9caa04a8e7c271422ad15b173"
    sha256 cellar: :any, x86_64_linux:      "60afb392ff0b4d26e804ab0d744e76246031abd869ed261de454ff0b2211a31d"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cppunit" => :build
  depends_on "libtool" => :build
  depends_on "maven" => :build
  depends_on "pkgconf" => :build

  depends_on "openjdk"
  depends_on "openssl@4"

  deny_network_access!

  def fetch
    system "mvn", "dependency:go-offline", "-Pfull-build"
  end

  def install
    openssl_prefix = dep("openssl").opt_prefix
    system "mvn", "install", "-Pfull-build", "-DskipTests", "-Dc-client-openssl=#{openssl_prefix}"

    system "tar", "-xf", "zookeeper-assembly/target/apache-zookeeper-#{version}-bin.tar.gz"
    binpfx = "apache-zookeeper-#{version}-bin"
    libexec.install binpfx+"/bin", binpfx+"/lib", "zookeeper-contrib"
    rm(Dir["build-bin/bin/*.cmd"])

    system "tar", "-xf", "zookeeper-assembly/target/apache-zookeeper-#{version}-lib.tar.gz"
    libpfx = "apache-zookeeper-#{version}-lib"
    include.install Dir[libpfx+"/usr/include/*"]
    lib.install Dir[libpfx+"/usr/lib/*"]

    (var/"log/zookeeper").mkpath
    (var/"run/zookeeper/data").mkpath

    libexec.glob("bin/*.sh") do |path|
      next if path == libexec/"bin/zkEnv.sh"

      script_name = path.basename
      bin_name    = path.basename ".sh"
      (bin/bin_name).write <<~BASH
        #!/bin/bash
        export JAVA_HOME="${JAVA_HOME:-#{formula_opt_prefix("openjdk")}}"
        . "#{pkgetc}/defaults"
        exec "#{libexec}/bin/#{script_name}" "$@"
      BASH
    end

    (buildpath/"defaults").write <<~ZSH
      [ -z "$ZOOCFGDIR" ] && export ZOOCFGDIR="#{pkgetc}"
    ZSH
    cp "conf/logback.xml", "logback.xml"
    cp "conf/zoo_sample.cfg", "conf/zoo.cfg"
    inreplace "conf/zoo.cfg",
              /^dataDir=.*/, "dataDir=#{var}/run/zookeeper/data"
    pkgetc.install "conf/zoo.cfg", "defaults", "logback.xml"
    (pkgshare/"examples").install "conf/logback.xml", "conf/zoo_sample.cfg"
  end

  service do
    run [opt_bin/"zkServer", "start-foreground"]
    environment_variables SERVER_JVMFLAGS: "-Dapple.awt.UIElement=true"
    keep_alive successful_exit: false
    working_dir var
  end

  test do
    output = shell_output("#{bin}/zkServer -h 2>&1")
    assert_match "Using config: #{pkgetc}/zoo.cfg", output
  end
end
