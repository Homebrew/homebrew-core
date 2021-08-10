class TomcatAT9 < Formula
  desc "Implementation of Java Servlet and JavaServer Pages"
  homepage "https://tomcat.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tomcat/tomcat-9/v9.0.52/bin/apache-tomcat-9.0.52.tar.gz"
  mirror "https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.52/bin/apache-tomcat-9.0.52.tar.gz"
  sha256 "29909c659fda7a2e06be17684a1fadbbae9ed4cdecf8077c4ede1c34e4d4a631"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "27567a8e9d0ddf80ec197734b2f5047c8e075992b6e47b5a805dd2581f59c5df"
  end

  keg_only :versioned_formula

  depends_on "openjdk"

  def install
    # Remove Windows scripts
    rm_rf Dir["bin/*.bat"]

    # Install files
    prefix.install %w[NOTICE LICENSE RELEASE-NOTES RUNNING.txt]
    libexec.install Dir["*"]
    (bin/"catalina").write_env_script "#{libexec}/bin/catalina.sh", JAVA_HOME: Formula["openjdk"].opt_prefix
  end

  service do
    run [opt_bin/"catalina", "run"]
    keep_alive true
  end

  test do
    ENV["CATALINA_BASE"] = testpath
    cp_r Dir["#{libexec}/*"], testpath
    rm Dir["#{libexec}/logs/*"]

    pid = fork do
      exec bin/"catalina", "start"
    end
    sleep 3
    begin
      system bin/"catalina", "stop"
    ensure
      Process.wait pid
    end
    assert_predicate testpath/"logs/catalina.out", :exist?
  end
end
