class TomeePlus < Formula
  desc "Everything in TomEE Web Profile and JAX-RS, plus more"
  homepage "https://tomee.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tomee/tomee-9.0.0/apache-tomee-9.0.0-plus.tar.gz"
  mirror "https://archive.apache.org/dist/tomee/tomee-9.0.0/apache-tomee-9.0.0-plus.tar.gz"
  sha256 "328c545bc94f4de1bfb915068b6929f3a5428506a12b88560719d6516f2e7de5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e207aba6ee6c8fca3198ab3246529eb150cc37635e74bfa7b556afca5772cf14"
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
