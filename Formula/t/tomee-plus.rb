class TomeePlus < Formula
  desc "Everything in TomEE Web Profile and JAX-RS, plus more"
  homepage "https://tomee.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tomee/tomee-9.1.1/apache-tomee-9.1.1-plus.tar.gz"
  mirror "https://archive.apache.org/dist/tomee/tomee-9.1.1/apache-tomee-9.1.1-plus.tar.gz"
  sha256 "92ff76417e28087ee30c99bbfcca9fe1e5672f7b78e785b7ba08e1f03f594451"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0561d1f6f41375865f9e0267da8e2db0e7658d580d1d0443cf292a4fc340efa5"
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
