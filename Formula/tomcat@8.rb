class TomcatAT8 < Formula
  desc "Implementation of Java Servlet and JavaServer Pages"
  homepage "https://tomcat.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tomcat/tomcat-8/v8.5.69/bin/apache-tomcat-8.5.69.tar.gz"
  mirror "https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.69/bin/apache-tomcat-8.5.69.tar.gz"
  sha256 "cc9616eb29bf491839ce5c8a1c3e37cb710f6ec99aad5aefb7944b5184b13398"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "f4cc617c4fff3908f63cb84a93dff830b164cd6d1c52dd258edb3be144b556bd"
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
