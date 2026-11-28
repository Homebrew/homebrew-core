class TomcatAT10 < Formula
  desc "Implementation of Java Servlet and JavaServer Pages"
  homepage "https://tomcat.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tomcat/tomcat-10/v10.1.62/bin/apache-tomcat-10.1.62.tar.gz"
  mirror "https://archive.apache.org/dist/tomcat/tomcat-10/v10.1.62/bin/apache-tomcat-10.1.62.tar.gz"
  sha256 "c5975715d22c909ebef0934669623c404414f66f35a4045cd00bb6f99e456ecf"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    manifest_sha256 "a6e1b97798e6bad0bcf9bd33ec80815cd7cfd7b953de55977754948d4c2e5cd1"
    sha256 cellar: :any_skip_relocation, all: "7ed01d51a53e87d96cb73a776e4d46687a07fe01b9e77523b19b97b35bcffb99"
  end

  keg_only :versioned_formula

  depends_on "openjdk"

  def install
    # Remove Windows scripts
    rm_r(Dir["bin/*.bat"])

    # Install files
    prefix.install %w[NOTICE LICENSE RELEASE-NOTES RUNNING.txt]

    pkgetc.install Dir["conf/*"]
    (buildpath/"conf").rmdir
    libexec.install_symlink pkgetc => "conf"

    libexec.install Dir["*"]
    (bin/"catalina").write_env_script "#{libexec}/bin/catalina.sh", JAVA_HOME: formula_opt_prefix("openjdk")
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
    assert_path_exists testpath/"logs/catalina.out"
  end
end
