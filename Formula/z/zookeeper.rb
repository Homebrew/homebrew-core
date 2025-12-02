class Zookeeper < Formula
  desc "Centralized server for distributed coordination of services"
  homepage "https://zookeeper.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=zookeeper/zookeeper-3.9.4/apache-zookeeper-3.9.4.tar.gz"
  mirror "https://archive.apache.org/dist/zookeeper/zookeeper-3.9.4/apache-zookeeper-3.9.4.tar.gz"
  sha256 "b84d0847d5b56c984fe3e50fdd28702340e66db5fd00701fa553d9899b09cabe"
  license "Apache-2.0"
  head "https://gitbox.apache.org/repos/asf/zookeeper.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "3a3e616c0425979bce887bb1877a1c9dbac8f7b1084d1063d0866cceb7e316e3"
    sha256 cellar: :any,                 arm64_sequoia: "c043dd88af99227da093e9ef7a1136c3312aad202434a400b72aaefffdca1ded"
    sha256 cellar: :any,                 arm64_sonoma:  "c0589e76ede2fd9ba0e3b72cfc76a8cfaf8a532eb6cc5444a1758de771cdef4d"
    sha256 cellar: :any,                 arm64_ventura: "753fb3e9dc9010f36e650e1314ed958b3e8ffcbf05eaa99c1bb4aa666dc85ca0"
    sha256 cellar: :any,                 sonoma:        "7ee73700ab93a4c025d257cd971bda6ef2529d628209f432b2ca14194cc7aa4b"
    sha256 cellar: :any,                 ventura:       "3b229907351bb11466ccf04ffa41d92f514d16f155842f5735ba9c4c8d0ada9b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ccad26bf750b09df6f7f3a4291360a1a3d172e295d7c8360a60a05e6dea8f4b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "241acb246366f78df065cba11917cc41845b185c520ca0632d5bf14d03c505db"
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
    <<~EOS
      [ -z "$ZOOCFGDIR" ] && export ZOOCFGDIR="#{pkgetc}"
    EOS
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
      (bin+bin_name).write <<~EOS
        #!/bin/bash
        export JAVA_HOME="${JAVA_HOME:-#{Formula["openjdk"].opt_prefix}}"
        . "#{pkgetc}/defaults"
        exec "#{libexec}/bin/#{script_name}" "$@"
      EOS
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
