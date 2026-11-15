class Zookeeper < Formula
  desc "Centralized server for distributed coordination of services"
  homepage "https://zookeeper.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=zookeeper/zookeeper-3.9.7/apache-zookeeper-3.9.7.tar.gz"
  mirror "https://archive.apache.org/dist/zookeeper/zookeeper-3.9.7/apache-zookeeper-3.9.7.tar.gz"
  sha256 "43142998ccb71a65cb18a354d1086163da9217a71d39b7c0464be9de41a286b8"
  license "Apache-2.0"
  compatibility_version 1
  head "https://gitbox.apache.org/repos/asf/zookeeper.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "1efde61644c462911189fc82e2021acea49fca8c8ab6e167ef2f8e4785f06fdf"
    sha256 cellar: :any, arm64_tahoe:       "fc805bcac17a6dbeb9b4c6ea9972222a8b23d8e675b4bda5897b3ec5d7a8aa38"
    sha256 cellar: :any, arm64_sequoia:     "bf1ef708334888ad6f50e75a4dd2da5a0b6c96f7f8032e58d9fff81fed9a3b51"
    sha256 cellar: :any, arm64_linux:       "e247fe7ef875a324ed1fbe7e590aa12e8ad021b8461cff668d10964a67d65772"
    sha256 cellar: :any, x86_64_linux:      "ca9587d2a981579c71d2181af0adce327e37281ecb9a10e864fe28f7393446c6"
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

  def default_zk_env
    <<~ZSH
      [ -z "$ZOOCFGDIR" ] && export ZOOCFGDIR="#{pkgetc}"
    ZSH
  end

  def fetch
    system "mvn", "dependency:go-offline", "-Pfull-build"
  end

  def install
    system "mvn", "install", "-Pfull-build", "-DskipTests", "-Dc-client-openssl=#{formula_opt_prefix("openssl@4")}"

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

    (buildpath/"defaults").write(default_zk_env)
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
