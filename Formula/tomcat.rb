class Tomcat < Formula
  desc "Implementation of Java Servlet and JavaServer Pages"
  homepage "https://tomcat.apache.org/"

  stable do
    url "https://www.apache.org/dyn/closer.cgi?path=tomcat/tomcat-8/v8.5.12/bin/apache-tomcat-8.5.12.tar.gz"
    mirror "https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.12/bin/apache-tomcat-8.5.12.tar.gz"
    sha256 "6d2cad1b595d0cc8083f9bbbb73c359d611249c7eaf283c40cb4ae4ca9c4644a"

    depends_on :java => "1.7+"

    resource "fulldocs" do
      url "https://www.apache.org/dyn/closer.cgi?path=/tomcat/tomcat-8/v8.5.12/bin/apache-tomcat-8.5.12-fulldocs.tar.gz"
      mirror "https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.12/bin/apache-tomcat-8.5.12-fulldocs.tar.gz"
      version "8.5.12"
      sha256 "7a2b4577c2e387a000f291b6a38291a84c547e529f3ecd55314ada812bfeb2be"
    end
  end

  devel do
    url "https://www.apache.org/dyn/closer.cgi?path=/tomcat/tomcat-9/v9.0.0.M18/bin/apache-tomcat-9.0.0.M18.tar.gz"
    mirror "https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.0.M18/bin/apache-tomcat-9.0.0.M18.tar.gz"
    version "9.0.0.M18"
    sha256 "75a0b023fcd9fcc31acc203940de840a2b31468b3eba55766c5fcd58402c722c"

    depends_on :java => "1.8+"

    resource "fulldocs" do
      url "https://www.apache.org/dyn/closer.cgi?path=/tomcat/tomcat-9/v9.0.0.M18/bin/apache-tomcat-9.0.0.M18-fulldocs.tar.gz"
      mirror "https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.0.M18/bin/apache-tomcat-9.0.0.M18-fulldocs.tar.gz"
      version "9.0.0.M18"
      sha256 "fd469c02070503a804d49a22de977f56453fd19086ea87d64aab01f20a59c2c8"
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
