class Tomcat < Formula
  desc "Implementation of Java Servlet and JavaServer Pages"
  homepage "https://tomcat.apache.org/"

  stable do
    url "https://www.apache.org/dyn/closer.cgi?path=tomcat/tomcat-8/v8.5.4/bin/apache-tomcat-8.5.4.tar.gz"
    mirror "https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.4/bin/apache-tomcat-8.5.4.tar.gz"
    sha256 "155cf7f09e13c63b8301ddc8c37d90be64bc3d5e9ddf163c4f10a6406a49a191"

    depends_on :java => "1.7+"

    resource "fulldocs" do
      url "https://www.apache.org/dyn/closer.cgi?path=/tomcat/tomcat-8/v8.5.4/bin/apache-tomcat-8.5.4-fulldocs.tar.gz"
      mirror "https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.4/bin/apache-tomcat-8.5.4-fulldocs.tar.gz"
      version "8.5.4"
      sha256 "3971b2c802860e3eb7902136cb421c953bb87c42fb510b0dcf65d604129453d2"
    end
  end

  devel do
    url "https://www.apache.org/dyn/closer.cgi?path=/tomcat/tomcat-9/v9.0.0.M9/bin/apache-tomcat-9.0.0.M9.tar.gz"
    version "9.0.0.M9"
    sha256 "aaeaebf271dd5c92c9aba808fb2efd1e32bc8cad01d13214fa0f3b594dece7fc"

    depends_on :java => "1.8+"

    resource "fulldocs" do
      url "https://www.apache.org/dyn/closer.cgi?path=/tomcat/tomcat-9/v9.0.0.M9/bin/apache-tomcat-9.0.0.M9-fulldocs.tar.gz"
      version "9.0.0.M9"
      sha256 "745e17f9715f4dc5ecefccf74135b4614efe859f334dafec94a5fb456b0ec43f"
    end
  end

  bottle :unneeded

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
