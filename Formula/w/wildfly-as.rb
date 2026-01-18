class WildflyAs < Formula
  desc "Managed application runtime for building applications"
  homepage "https://www.wildfly.org/"
  url "https://github.com/wildfly/wildfly/releases/download/39.0.0.Final/wildfly-39.0.0.Final.tar.gz"
  sha256 "e8ef56989c9526f314061a27575e62b9ce9c74989bfd3dab1df8d678c12d9f79"
  license "Apache-2.0"

  livecheck do
    url "https://www.wildfly.org/downloads/"
    regex(/href=.*?wildfly[._-]v?(\d+(?:\.\d+)+)\.Final\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3784ee62fb86b1338f4cb5d5739f637e7de05c0b7892b501fbf21a1b7de5c364"
    sha256 cellar: :any, arm64_sequoia: "d3b0d5552512465ea376c286f40b51da4812648e453232f276bb639a474b4829"
    sha256 cellar: :any, arm64_sonoma:  "d3b0d5552512465ea376c286f40b51da4812648e453232f276bb639a474b4829"
    sha256 cellar: :any, sonoma:        "06ade82cace0842c03aa5c927ade5d89d7a2f331cab1152b5bdd4f270c2b583c"
  end

  # Installs a pre-built `libartemis-native-64.so` file with linkage to libaio.so.1
  depends_on :macos
  depends_on "openjdk"

  def install
    buildpath.glob("bin/*.{bat,ps1}").map(&:unlink)
    rm_r buildpath.glob("**/win-x86_64")
    rm_r buildpath.glob("**/linux-i686")
    rm_r buildpath.glob("**/linux-s390x")
    rm_r buildpath.glob("**/linux-x86_64")
    rm_r buildpath.glob("**/netty-transport-native-epoll/**/native")
    if Hardware::CPU.intel?
      buildpath.glob("**/*_aarch_64.jnilib").map(&:unlink)
    else
      rm_r buildpath.glob("**/macosx-x86_64")
      buildpath.glob("**/*_x86_64.jnilib").map(&:unlink)
    end

    inreplace "bin/standalone.sh", /JAVA="[^"]*"/, "JAVA='#{Formula["openjdk"].opt_bin}/java'"

    libexec.install Dir["*"]
    mkdir_p libexec/"standalone/log"
  end

  def caveats
    <<~EOS
      The home of WildFly Application Server #{version} is:
        #{opt_libexec}
      You may want to add the following to your .bash_profile:
        export JBOSS_HOME=#{opt_libexec}
        export PATH=${PATH}:${JBOSS_HOME}/bin
    EOS
  end

  service do
    run [opt_libexec/"bin/standalone.sh", "--server-config=standalone.xml"]
    environment_variables JBOSS_HOME: opt_libexec, WILDFLY_HOME: opt_libexec
    keep_alive successful_exit: false, crashed: true
  end

  test do
    ENV["JBOSS_HOME"] = opt_libexec
    ENV["JBOSS_LOG_DIR"] = testpath

    port = free_port

    pidfile = testpath/"pidfile"
    ENV["LAUNCH_JBOSS_IN_BACKGROUND"] = "true"
    ENV["JBOSS_PIDFILE"] = pidfile

    mkdir testpath/"standalone"
    mkdir testpath/"standalone/deployments"
    cp_r libexec/"standalone/configuration", testpath/"standalone"
    spawn opt_libexec/"bin/standalone.sh", "--server-config=standalone.xml",
                                           "-Djboss.http.port=#{port}",
                                           "-Djboss.server.base.dir=#{testpath}/standalone"
    begin
      sleep 10
      sleep 10 if Hardware::CPU.intel?
      system "curl", "-X", "GET", "localhost:#{port}/"
      output = shell_output("curl -s -X GET localhost:#{port}")
      assert_match "Welcome to WildFly", output
    ensure
      Process.kill "SIGTERM", pidfile.read.to_i
    end
  end
end
