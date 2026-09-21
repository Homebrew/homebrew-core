class Zookeeper < Formula
  desc "Centralized server for distributed coordination of services"
  homepage "https://zookeeper.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=zookeeper/zookeeper-3.9.6/apache-zookeeper-3.9.6.tar.gz"
  mirror "https://archive.apache.org/dist/zookeeper/zookeeper-3.9.6/apache-zookeeper-3.9.6.tar.gz"
  sha256 "9277edd177f795c68b3a92cb411a79076b12ad3184fbf900c0d7cec9a0a52e0a"
  license "Apache-2.0"
  head "https://gitbox.apache.org/repos/asf/zookeeper.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "fbd2050163a7a2b34a3cd0e9c786b3031827d0225bb93285c5de3c4ba104487e"
    sha256 cellar: :any, arm64_tahoe:       "0cf4ac55a57f36c1fb6f565ef14cc9e4e5a52c20b497fd4737ea2ec9714ae983"
    sha256 cellar: :any, arm64_sequoia:     "8156fb198b4f09fa2492eaa3d96c4eb82d355db5aee9915c654f624da508fae4"
    sha256 cellar: :any, arm64_linux:       "5d1b304ab278b7f2402a8b44fc1c86611823e626115cd34ca71cb45658927ced"
    sha256 cellar: :any, x86_64_linux:      "a414f7fa9d373ef44c9f3ec12a6805d4a52437039377d500c1a80f4ad9ecf27a"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cppunit" => :build
  depends_on "libtool" => :build
  depends_on "maven" => :build
  depends_on "pkgconf" => :build

  depends_on "openjdk"
  depends_on "openssl@3"

  def default_zk_env
    <<~ZSH
      [ -z "$ZOOCFGDIR" ] && export ZOOCFGDIR="#{pkgetc}"
    ZSH
  end

  def install
    system "mvn", "install", "-Pfull-build", "-DskipTests"

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

    Pathname.glob("#{libexec}/bin/*.sh") do |path|
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
