class TomcatAT80 < Formula
  desc "Implementation of Java Servlet and JavaServer Pages"
  homepage "https://tomcat.apache.org/"

  stable do
    url "https://www.apache.org/dyn/closer.cgi?path=tomcat/tomcat-8/v8.0.43/bin/apache-tomcat-8.0.43.tar.gz"
    sha256 "b8709ca3e3446d52958d6ed85387aa0d5c5288e5a492fc8c9cac4c5c64180691"

    depends_on :java => "1.7+"

    resource "fulldocs" do
      url "https://www.apache.org/dyn/closer.cgi?path=tomcat/tomcat-8/v8.0.43/bin/apache-tomcat-8.0.43-fulldocs.tar.gz"
      mirror "https://archive.apache.org/dist/tomcat/tomcat-8/v8.0.43/bin/apache-tomcat-8.0.43-fulldocs.tar.gz"
      version "8.0.43"
      sha256 "568bd83e85e0f1b66470b19f6198ea705061379e8d92188dae7acd7aa3bd6568"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "8cb785857c3e1929cb0a73343d89f5054ea7b09b70ad38766d80efb396aa933f" => :sierra
    sha256 "b9775fa8e0ecdc7320d82b661c77ab9bf525a505713345883307dcf2089bfba9" => :el_capitan
    sha256 "b9775fa8e0ecdc7320d82b661c77ab9bf525a505713345883307dcf2089bfba9" => :yosemite
  end

  keg_only :versioned_formula

  option "with-fulldocs", "Install full documentation locally"

  def install
    # Remove Windows scripts
    rm_rf Dir["bin/*.bat"]

    # Install files
    prefix.install %w[NOTICE LICENSE RELEASE-NOTES RUNNING.txt]
    libexec.install Dir["*"]
    bin.install_symlink "#{libexec}/bin/catalina.sh" => "catalina"

    (share/"fulldocs").install resource("fulldocs") if build.with? "fulldocs"
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
    File.exist? testpath/"logs/catalina.out"
  end
end
