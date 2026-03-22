class WildflyAs < Formula
  desc "Managed application runtime for building applications"
  homepage "https://www.wildfly.org/"
  url "https://github.com/wildfly/wildfly/releases/download/39.0.1.Final/wildfly-39.0.1.Final.tar.gz"
  sha256 "30ce0874378d1100289d4820fce1f7646ab1278f8c30c7ae9bb84c16cbd510cb"
  license "Apache-2.0"

  livecheck do
    url "https://www.wildfly.org/downloads/"
    regex(/href=.*?wildfly[._-]v?(\d+(?:\.\d+)+)\.Final\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "517a2a569b58e638fca4cb6fe98229af72d3ae567a7293d6d2516df00a05ceb8"
    sha256 cellar: :any, arm64_sequoia: "71e35def71769915026776c48a02d4aaaa5f2bb0286a054b8cb146f336c97dcf"
    sha256 cellar: :any, arm64_sonoma:  "71e35def71769915026776c48a02d4aaaa5f2bb0286a054b8cb146f336c97dcf"
    sha256 cellar: :any, sonoma:        "f64f965a4165eccc9a83ddf2ed5358eff7ac790c904c59d801c36baa54e54d13"
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
