class TomcatAT9 < Formula
  desc "Implementation of Java Servlet and JavaServer Pages"
  homepage "https://tomcat.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tomcat/tomcat-9/v9.0.89/bin/apache-tomcat-9.0.89.tar.gz"
  mirror "https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.89/bin/apache-tomcat-9.0.89.tar.gz"
  sha256 "cb8aed230aa2f15cc5c2439b044dd88d6ec8900e46d81ee63c4d1090c0937e32"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4791c85cadaa704672615bcf3022ac9b7fc8b96bbd01296232e45b96b7f015a0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "14dc7b2b13c80ab6366ac26fbecaba102d145c85592d884bf2b8990abbc69806"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6502bdefe0b3dd2443d34b5e204203ce86f78fb989a708d28863aaf5be3d3429"
    sha256 cellar: :any_skip_relocation, sonoma:         "87f5dfe88df091fa6969e9bac65e8f276c2e7ec5ff1d79641502b161125e943c"
    sha256 cellar: :any_skip_relocation, ventura:        "06e9b099ab691b202bb15d008764a243db0f22c09c6f79f04bcc4b53356d09ee"
    sha256 cellar: :any_skip_relocation, monterey:       "778010b92f56709990a566491f0d6cdc9e52246d103edfabb1386e3dac35758d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56c4618876ab1bab344c996a183a427b0acd5572ed6c97ace37630655dd17802"
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
