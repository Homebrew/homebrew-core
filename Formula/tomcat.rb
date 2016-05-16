class Tomcat < Formula
  desc "Implementation of Java Servlet and JavaServer Pages"
  homepage "https://tomcat.apache.org/"

  stable do
    url "https://www.apache.org/dyn/closer.cgi?path=tomcat/tomcat-8/v8.0.35/bin/apache-tomcat-8.0.35.tar.gz"
    mirror "https://www.apache.org/dist/tomcat/tomcat-8/v8.0.35/bin/apache-tomcat-8.0.35.tar.gz"
    sha256 "6bc380aeebe0b56cf9b37b8c3c128919d2e8ac84d756448fc8e9d8af122f88fd"

    depends_on :java => "1.7+"

    resource "fulldocs" do
      url "https://www.apache.org/dyn/closer.cgi?path=/tomcat/tomcat-8/v8.0.35/bin/apache-tomcat-8.0.35-fulldocs.tar.gz"
      mirror "https://www.apache.org/dist/tomcat/tomcat-8/v8.0.35/bin/apache-tomcat-8.0.35-fulldocs.tar.gz"
      version "8.0.35"
      sha256 "572e91559b7ade53f69ef5d0277db19717c672963ef10b719b8f4b7cd2c79ccf"
    end
  end

  devel do
    url "https://www.apache.org/dyn/closer.cgi?path=/tomcat/tomcat-8/v8.5.2/bin/apache-tomcat-8.5.2.tar.gz"
    mirror "https://www.apache.org/dist/tomcat/tomcat-8/v8.5.2/bin/apache-tomcat-8.5.2.tar.gz"
    sha256 "6b504d7de9b33f234b1c1639b187208ef5dbf5d0f0d413b6f351fc115196396e"

    resource "fulldocs" do
      url "https://www.apache.org/dyn/closer.cgi?path=/tomcat/tomcat-8/v8.5.2/bin/apache-tomcat-8.5.2-fulldocs.tar.gz"
      mirror "https://www.apache.org/dist/tomcat/tomcat-8/v8.5.2/bin/apache-tomcat-8.5.2-fulldocs.tar.gz"
      version "8.5.2"
      sha256 "9e150f98803ceef8be0bb415a9eaf8de4e689c20a4c020b5aec85c05547dccd1"
    end
  end

  bottle :unneeded

  option "with-fulldocs", "Install full documentation locally"

  def install
    # Remove Windows scripts
    rm_rf Dir["bin/*.bat"]

    # Install files
    prefix.install %w[ NOTICE LICENSE RELEASE-NOTES RUNNING.txt ]
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
