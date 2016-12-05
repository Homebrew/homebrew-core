class TomcatAT7 < Formula
  desc "Implementation of Java Servlet and JavaServer Pages"
  homepage "https://tomcat.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=tomcat/tomcat-7/v7.0.73/bin/apache-tomcat-7.0.73.tar.gz"
  sha256 "0e814d6ad7d5b90e29c79887137420d3bc413540f9faa60d98f11e6c8a8fea85"

  bottle :unneeded

  option "with-fulldocs", "Install full documentation locally"

  depends_on :java

  conflicts_with "tomcat", :because => "Differing versions of same formula"
  conflicts_with "tomcat@6", :because => "Differing versions of same formula"

  resource "fulldocs" do
    url "https://www.apache.org/dyn/closer.cgi?path=/tomcat/tomcat-7/v7.0.73/bin/apache-tomcat-7.0.73-fulldocs.tar.gz"
    version "7.0.73"
    sha256 "ef1395034fd59cea38aaeee853e2630a1fb6e59c3fd0f398c2ffbe7893fd450b"
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
