class TomeePlus < Formula
  desc "Everything in TomEE Web Profile and JAX-RS, plus more"
  homepage "https://tomee.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tomee/tomee-10.1.3/apache-tomee-10.1.3-plus.tar.gz"
  mirror "https://archive.apache.org/dist/tomee/tomee-10.1.3/apache-tomee-10.1.3-plus.tar.gz"
  sha256 "d1a415ff468ecfb9404a8e12100701124d0f1bc026ff7c9d85ccf93165756cfc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2b511d2cca1bd53f24058d947038855d7a381a4d767d70c8a073a1745960c298"
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
