class TomcatAT9 < Formula
  desc "Implementation of Java Servlet and JavaServer Pages"
  homepage "https://tomcat.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tomcat/tomcat-9/v9.0.62/bin/apache-tomcat-9.0.62.tar.gz"
  mirror "https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.62/bin/apache-tomcat-9.0.62.tar.gz"
  sha256 "03157728a832cf9c83048cdc28d09600cbb3e4fa087f8b97d74c8b4f34cd89bb"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c94f32571d3255b5065c1f43ee612912cae8fe7e112efc257d86cc653636981e"
  end

  keg_only :versioned_formula

  depends_on "openjdk"

  def install
    # Remove Windows scripts
    rm_rf Dir["bin/*.bat"]

    # Install files
    prefix.install %w[NOTICE LICENSE RELEASE-NOTES RUNNING.txt]

    pkgetc.install Dir["conf/*"]
    (buildpath/"conf").rmdir
    libexec.install_symlink pkgetc => "conf"

    libexec.install Dir["*"]
    (bin/"catalina").write_env_script "#{libexec}/bin/catalina.sh", Language::Java.overridable_java_home_env
  end

  def caveats
    <<~EOS
      Configuration files: #{pkgetc}
    EOS
  end

  service do
    run [opt_bin/"catalina", "run"]
    keep_alive true
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
    assert_predicate testpath/"logs/catalina.out", :exist?
  end
end
