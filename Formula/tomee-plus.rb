class TomeePlus < Formula
  desc "Everything in TomEE Web Profile and JAX-RS, plus more"
  homepage "https://tomee.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tomee/tomee-8.0.10/apache-tomee-8.0.10-plus.tar.gz"
  mirror "https://archive.apache.org/dist/tomee/tomee-8.0.10/apache-tomee-8.0.10-plus.tar.gz"
  sha256 "5fc283b35aa8366a9330f2dbac0959e0d51113674e092c37cc4adc5879a52587"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ae8817e1cf4f363655d645db6b2defbcc09ab41c97ece3b85278e095ff3fa4c1"
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
