class TomcatAT7 < Formula
  desc "Implementation of Java Servlet and JavaServer Pages"
  homepage "https://tomcat.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tomcat/tomcat-7/v7.0.109/bin/apache-tomcat-7.0.109.tar.gz"
  mirror "https://archive.apache.org/dist/tomcat/tomcat-7/v7.0.109/bin/apache-tomcat-7.0.109.tar.gz"
  sha256 "ebfeb051e6da24bce583a4105439bfdafefdc7c5bdd642db2ab07e056211cb31"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "5c8fb4abdff431b9aae276c2010e8258fcf817194175dfa614fd22c046882474"
  end

  keg_only :versioned_formula

  depends_on "openjdk"

  # Keep log folders
  skip_clean "libexec"

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
