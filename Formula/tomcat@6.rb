class TomcatAT6 < Formula
  desc "Implementation of Java Servlet and JavaServer Pages"
  homepage "https://tomcat.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=tomcat/tomcat-6/v6.0.51/bin/apache-tomcat-6.0.51.tar.gz"
  sha256 "8fe88622ba099110a5f6b85856af262a55f79e31700525fe0d2e961433b3a6b9"

  bottle :unneeded

  keg_only :versioned_formula

  option "with-fulldocs", "Install full documentation locally"

  depends_on :java

  resource "fulldocs" do
    url "https://www.apache.org/dyn/closer.cgi?path=/tomcat/tomcat-6/v6.0.51/bin/apache-tomcat-6.0.51-fulldocs.tar.gz"
    version "6.0.51"
    sha256 "e55e70d17f0a648c268afb83787f0f8714aabf3800c22b4c8157774a08a37d44"
  end

  def install
    rm_rf Dir["bin/*.{cmd,bat]}"]
    libexec.install Dir["*"]
    (libexec+"logs").mkpath
    bin.mkpath
    Dir["#{libexec}/bin/*.sh"].each { |f| ln_s f, bin }
    (share/"fulldocs").install resource("fulldocs") if build.with? "fulldocs"
  end

  def caveats; <<-EOS.undent
    Some of the support scripts used by Tomcat have very generic names.
    These are likely to conflict with support scripts used by other Java-based
    server software.
    You can add #{bin} to your PATH instead.
    EOS
  end

  test do
    ENV["CATALINA_BASE"] = testpath
    cp_r Dir["#{libexec}/*"], testpath
    rm Dir["#{libexec}/logs/*"]

    pid = fork do
      exec bin/"catalina.sh", "start"
    end
    sleep 3
    begin
      system bin/"catalina.sh", "stop"
    ensure
      Process.wait pid
    end
    File.exist? testpath/"logs/catalina.out"
  end
end
