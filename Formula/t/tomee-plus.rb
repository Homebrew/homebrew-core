class TomeePlus < Formula
  desc "Everything in TomEE Web Profile and JAX-RS, plus more"
  homepage "https://tomee.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tomee/tomee-10.1.2/apache-tomee-10.1.2-plus.tar.gz"
  mirror "https://archive.apache.org/dist/tomee/tomee-10.1.2/apache-tomee-10.1.2-plus.tar.gz"
  sha256 "d64bcd00029ba3ea51c59263a581eff6da0df5b24f636dfdf83755dc2f765698"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2187a93f5e98f9218fd17c15ce08094801059fb29be871dfbc2279182d401181"
  end

  depends_on "openjdk"

  def install
    # Remove Windows scripts
    rm_r(Dir["bin/*.bat"])
    rm_r(Dir["bin/*.bat.original"])
    rm_r(Dir["bin/*.exe"])

    # Install files
    prefix.install %w[NOTICE LICENSE RELEASE-NOTES RUNNING.txt]
    libexec.install Dir["*"]
    (bin/"tomee-plus-startup").write_env_script "#{libexec}/bin/startup.sh",
                                                Language::Java.overridable_java_home_env
  end

  def caveats
    <<~EOS
      The home of Apache TomEE Plus is:
        #{opt_libexec}
      To run Apache TomEE:
        #{opt_libexec}/bin/tomee-plus-startup
    EOS
  end

  test do
    ENV["JAVA_HOME"] = Formula["openjdk"].opt_prefix
    system "#{opt_libexec}/bin/configtest.sh"
  end
end
