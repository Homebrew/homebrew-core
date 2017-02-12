class TomcatAT80 < Formula
  desc "Implementation of Java Servlet and JavaServer Pages"
  homepage "https://tomcat.apache.org/"

  stable do
    url "https://www.apache.org/dyn/closer.cgi?path=tomcat/tomcat-8/v8.0.41/bin/apache-tomcat-8.0.41.tar.gz"
    sha256 "a57204b5434755b5767299bbcd32e3afd2d6327cafa6b8372077f824aa7176d7"

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
    sha256 "27b4bd9d7509536c643c3ccc4c572385f00831c2e9abc3b2321ff226c25ec7aa" => :sierra
    sha256 "27b4bd9d7509536c643c3ccc4c572385f00831c2e9abc3b2321ff226c25ec7aa" => :el_capitan
    sha256 "27b4bd9d7509536c643c3ccc4c572385f00831c2e9abc3b2321ff226c25ec7aa" => :yosemite
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
