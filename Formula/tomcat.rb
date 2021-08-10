class Tomcat < Formula
  desc "Implementation of Java Servlet and JavaServer Pages"
  homepage "https://tomcat.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tomcat/tomcat-10/v10.0.10/bin/apache-tomcat-10.0.10.tar.gz"
  mirror "https://archive.apache.org/dist/tomcat/tomcat-10/v10.0.10/bin/apache-tomcat-10.0.10.tar.gz"
  sha256 "cd1e27216cd8dad1e9b7f9a0a4107c7148b748eb646f2aee45a11016d1268bb2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0cdfbbdd72060205ff5346d2046f8369779623221c09ed52c6e990a1c2107752"
  end

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
