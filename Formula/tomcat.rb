class Tomcat < Formula
  desc "Implementation of Java Servlet and JavaServer Pages"
  homepage "https://tomcat.apache.org/"

  stable do
    url "https://www.apache.org/dyn/closer.cgi?path=tomcat/tomcat-8/v8.5.15/bin/apache-tomcat-8.5.15.tar.gz"
    mirror "https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.15/bin/apache-tomcat-8.5.15.tar.gz"
    sha256 "7fb92567df38c6e1f86081cbf864d308d0cf520586a5bac052a6c6037f42dd91"

    depends_on :java => "1.7+"

    resource "fulldocs" do
      url "https://www.apache.org/dyn/closer.cgi?path=/tomcat/tomcat-8/v8.5.15/bin/apache-tomcat-8.5.15-fulldocs.tar.gz"
      mirror "https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.15/bin/apache-tomcat-8.5.15-fulldocs.tar.gz"
      version "8.5.15"
      sha256 "f85e0188fc220f11a0805de0e5712dd263de406513a7ae913869da30da8b0fd6"
    end
  end

  devel do
    url "https://www.apache.org/dyn/closer.cgi?path=/tomcat/tomcat-9/v9.0.0.M21/bin/apache-tomcat-9.0.0.M21.tar.gz"
    mirror "https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.0.M21/bin/apache-tomcat-9.0.0.M21.tar.gz"
    version "9.0.0.M21"
    sha256 "c959c5a8ef09af269ddb0681d428f82ff5b3ba10ffbff177f671938f27ca7cee"

    depends_on :java => "1.8+"

    resource "fulldocs" do
      url "https://www.apache.org/dyn/closer.cgi?path=/tomcat/tomcat-9/v9.0.0.M21/bin/apache-tomcat-9.0.0.M21-fulldocs.tar.gz"
      mirror "https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.0.M21/bin/apache-tomcat-9.0.0.M21-fulldocs.tar.gz"
      version "9.0.0.M21"
      sha256 "156c8e66827a2261ba794acd52eac1542404e528e680948fcf7b2510d15ff7ef"
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
