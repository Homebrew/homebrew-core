class TomcatAT6 < Formula
  desc "Implementation of Java Servlet and JavaServer Pages"
  homepage "https://tomcat.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=tomcat/tomcat-6/v6.0.53/bin/apache-tomcat-6.0.53.tar.gz"
  sha256 "35249a4b40f41fb5f602f5602142d59faaa96dc1567df807d108d4d2b942e2f0"

  bottle :unneeded

  keg_only :versioned_formula

  option "with-fulldocs", "Install full documentation locally"

  depends_on :java

  resource "fulldocs" do
    url "https://www.apache.org/dyn/closer.cgi?path=/tomcat/tomcat-6/v6.0.53/bin/apache-tomcat-6.0.53-fulldocs.tar.gz"
    sha256 "3465db40f8b6f048e0733444668e4a40e9814855e5112762f3bb14e45eb9724a"
  end

  def install
    rm_rf Dir["bin/*.{cmd,bat]}"]
    libexec.install Dir["*"]
    (libexec+"logs").mkpath
    bin.mkpath
    Dir["#{libexec}/bin/*.sh"].each { |f| ln_s f, bin }
    (share/"fulldocs").install resource("fulldocs") if build.with? "fulldocs"
  end

  def caveats; <<~EOS
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
    assert_predicate testpath/"logs/catalina.out", :exist?
  end
end
