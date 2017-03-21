class TomcatAT7 < Formula
  desc "Implementation of Java Servlet and JavaServer Pages"
  homepage "https://tomcat.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=tomcat/tomcat-7/v7.0.76/bin/apache-tomcat-7.0.76.tar.gz"
  sha256 "63ccbb0ad37077a01e1fcd2b7cfd48d94007759194dcbcd2fbe10dee85bc46be"

  bottle :unneeded

  keg_only :versioned_formula

  option "with-fulldocs", "Install full documentation locally"

  depends_on :java

  resource "fulldocs" do
    url "https://www.apache.org/dyn/closer.cgi?path=/tomcat/tomcat-7/v7.0.76/bin/apache-tomcat-7.0.76-fulldocs.tar.gz"
    version "7.0.76"
    sha256 "fc35ec1ed0eb17da9cc400f978213c38b1283c8d04df32110e5c41eb664b794f"
  end

  # Keep log folders
  skip_clean "libexec"

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
