class TomeePlus < Formula
  desc "Everything in TomEE Web Profile and JAX-RS, plus more"
  homepage "https://tomee.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tomee/tomee-8.0.12/apache-tomee-8.0.12-plus.tar.gz"
  mirror "https://archive.apache.org/dist/tomee/tomee-8.0.12/apache-tomee-8.0.12-plus.tar.gz"
  sha256 "a496ac0816e30e118927544aa4bd9255b562817bd4b04dda58cd21ca3b0d4bc4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d116a14ffa3e57783ad509104b2c6e5caa77c9a30d547ed5a53220afeb76099b"
  end

  depends_on "openjdk"

  def install
    # Remove Windows scripts
    rm_rf Dir["bin/*.bat"]
    rm_rf Dir["bin/*.bat.original"]
    rm_rf Dir["bin/*.exe"]

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
