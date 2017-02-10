class TomcatAT80 < Formula
  desc "Implementation of Java Servlet and JavaServer Pages"
  homepage "https://tomcat.apache.org/"
  revision 1

  stable do
    url "https://www.apache.org/dyn/closer.cgi?path=tomcat/tomcat-8/v8.0.39/bin/apache-tomcat-8.0.39.tar.gz"
    mirror "https://archive.apache.org/dist/tomcat/tomcat-8/v8.0.39/bin/apache-tomcat-8.0.39.tar.gz"
    sha256 "4093aa19f70ebb2749d40fa81486971c1dc7f275da188f1436c62faedaf51e9a"

    depends_on :java => "1.7+"

    resource "fulldocs" do
      url "https://www.apache.org/dyn/closer.cgi?path=/tomcat/tomcat-8/v8.0.39/bin/apache-tomcat-8.0.39-fulldocs.tar.gz"
      mirror "https://archive.apache.org/dist/tomcat/tomcat-8/v8.0.39/bin/apache-tomcat-8.0.39-fulldocs.tar.gz"
      version "8.0.39"
      sha256 "198d67aa67de1a7262e9aa31945a9f53804c37051096c3147c978920ff00a2f6"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "59d632c9b8ca3db3de566e1b942ede7e6c11210c8d94bd83d8d54f63dea1bef9" => :sierra
    sha256 "dce932f72025955946012f02948eed9252ca635121a6228ae144bce7e93de672" => :el_capitan
    sha256 "59d632c9b8ca3db3de566e1b942ede7e6c11210c8d94bd83d8d54f63dea1bef9" => :yosemite
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
