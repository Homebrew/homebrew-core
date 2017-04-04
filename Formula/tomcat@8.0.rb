class TomcatAT80 < Formula
  desc "Implementation of Java Servlet and JavaServer Pages"
  homepage "https://tomcat.apache.org/"

  stable do
    url "https://www.apache.org/dyn/closer.cgi?path=tomcat/tomcat-8/v8.0.42/bin/apache-tomcat-8.0.42.tar.gz"
    sha256 "be876f955657791a480c167ea126663f56aa908da5c354bd4b3d60b3aa5c6e1e"

    depends_on :java => "1.7+"

    resource "fulldocs" do
      url "https://www.apache.org/dyn/closer.cgi?path=/tomcat/tomcat-8/v8.0.42/bin/apache-tomcat-8.0.42-fulldocs.tar.gz"
      mirror "https://archive.apache.org/dist/tomcat/tomcat-8/v8.0.42/bin/apache-tomcat-8.0.42-fulldocs.tar.gz"
      version "8.0.42"
      sha256 "788a9981307d53ef3292dee2cf66c32d38b8e8235763d6b98ba12d16d397d2cb"
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
