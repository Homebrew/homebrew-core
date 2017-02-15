class TomcatAT7 < Formula
  desc "Implementation of Java Servlet and JavaServer Pages"
  homepage "https://tomcat.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=tomcat/tomcat-7/v7.0.75/bin/apache-tomcat-7.0.75.tar.gz"
  sha256 "d19a2fbbc23e310296d1e978f8e8f977b54cd328ce10cd879b58a443bc6eaa70"

  bottle :unneeded

  keg_only :versioned_formula

  option "with-fulldocs", "Install full documentation locally"

  depends_on :java

  resource "fulldocs" do
    url "https://www.apache.org/dyn/closer.cgi?path=/tomcat/tomcat-7/v7.0.75/bin/apache-tomcat-7.0.75-fulldocs.tar.gz"
    version "7.0.75"
    sha256 "fa8e9316d4f6b4bade2ff4607f61a1fd9010f538b502d792fa466bd27e3e16d9"
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
