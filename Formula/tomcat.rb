class Tomcat < Formula
  desc "Implementation of Java Servlet and JavaServer Pages"
  homepage "https://tomcat.apache.org/"

  stable do
    url "https://www.apache.org/dyn/closer.cgi?path=tomcat/tomcat-8/v8.5.16/bin/apache-tomcat-8.5.16.tar.gz"
    mirror "https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.16/bin/apache-tomcat-8.5.16.tar.gz"
    sha256 "939fb7c9fae3298dd0ccb4724b9c943c524e8af287531c8f3bbec0707e5780f1"

    depends_on :java => "1.7+"

    resource "fulldocs" do
      url "https://www.apache.org/dyn/closer.cgi?path=/tomcat/tomcat-8/v8.5.16/bin/apache-tomcat-8.5.16-fulldocs.tar.gz"
      mirror "https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.16/bin/apache-tomcat-8.5.16-fulldocs.tar.gz"
      version "8.5.16"
      sha256 "89fb481635834af7abc9cfefd67b530f1f3154c3bc2a820ceeb80e2e9c0d91c0"
    end
  end

  devel do
    url "https://www.apache.org/dyn/closer.cgi?path=/tomcat/tomcat-9/v9.0.0.M22/bin/apache-tomcat-9.0.0.M22.tar.gz"
    mirror "https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.0.M22/bin/apache-tomcat-9.0.0.M22.tar.gz"
    version "9.0.0.M22"
    sha256 "c1b359d52edae793dde83cb65ef47dc202e8394d7328c823a9a53c02d09f2742"

    depends_on :java => "1.8+"

    resource "fulldocs" do
      url "https://www.apache.org/dyn/closer.cgi?path=/tomcat/tomcat-9/v9.0.0.M22/bin/apache-tomcat-9.0.0.M22-fulldocs.tar.gz"
      mirror "https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.0.M22/bin/apache-tomcat-9.0.0.M22-fulldocs.tar.gz"
      version "9.0.0.M22"
      sha256 "57223a9dd8d1b164a492432f04fbcf02a390777e2aaa252b5574d5ed607acc60"
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
