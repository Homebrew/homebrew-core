class WildflyAs < Formula
  desc "Managed application runtime for building applications"
  homepage "https://www.wildfly.org/"
  url "https://github.com/wildfly/wildfly/releases/download/28.0.1.Final/wildfly-28.0.1.Final.tar.gz"
  sha256 "6224d4b88a79d58c319bed5fb7b44f08de26d7111c68128732b24ae08074cbfd"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://www.wildfly.org/downloads/"
    regex(/href=.*?wildfly[._-]v?(\d+(?:\.\d+)+)\.Final\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "89984e80061d0973be062542db8ab821f2985bd2eb895ae3fe5cdbd2a8220283"
    sha256 cellar: :any, arm64_monterey: "89984e80061d0973be062542db8ab821f2985bd2eb895ae3fe5cdbd2a8220283"
    sha256 cellar: :any, arm64_big_sur:  "89984e80061d0973be062542db8ab821f2985bd2eb895ae3fe5cdbd2a8220283"
    sha256 cellar: :any, ventura:        "dd476c610cb14a5457f0e2152b86b7530cb8a3037f9fecf553d802b749bf2790"
    sha256 cellar: :any, monterey:       "dd476c610cb14a5457f0e2152b86b7530cb8a3037f9fecf553d802b749bf2790"
    sha256 cellar: :any, big_sur:        "dd476c610cb14a5457f0e2152b86b7530cb8a3037f9fecf553d802b749bf2790"
  end

  # Installs a pre-built `libartemis-native-64.so` file with linkage to libaio.so.1
  depends_on :macos
  depends_on "openjdk"

  def install
    buildpath.glob("bin/*.{bat,ps1}").map(&:unlink)
    buildpath.glob("**/win-x86_64").map(&:rmtree)
    buildpath.glob("**/linux-i686").map(&:rmtree)
    buildpath.glob("**/linux-s390x").map(&:rmtree)
    buildpath.glob("**/linux-x86_64").map(&:rmtree)
    buildpath.glob("**/netty-transport-native-epoll/**/native").map(&:rmtree)
    if Hardware::CPU.intel?
      buildpath.glob("**/*_aarch_64.jnilib").map(&:unlink)
    else
      buildpath.glob("**/macosx-x86_64").map(&:rmtree)
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
    system "#{opt_libexec}/bin/standalone.sh --version | grep #{version}"

    port = free_port

    pidfile = testpath/"pidfile"
    ENV["LAUNCH_JBOSS_IN_BACKGROUND"] = "true"
    ENV["JBOSS_PIDFILE"] = pidfile

    mkdir testpath/"standalone"
    mkdir testpath/"standalone/deployments"
    cp_r libexec/"standalone/configuration", testpath/"standalone"
    fork do
      exec opt_libexec/"bin/standalone.sh", "--server-config=standalone.xml",
                                            "-Djboss.http.port=#{port}",
                                            "-Djboss.server.base.dir=#{testpath}/standalone"
    end
    sleep 10

    begin
      system "curl", "-X", "GET", "localhost:#{port}/"
      output = shell_output("curl -s -X GET localhost:#{port}")
      assert_match "Welcome to WildFly", output
    ensure
      Process.kill "SIGTERM", pidfile.read.to_i
    end
  end
end
