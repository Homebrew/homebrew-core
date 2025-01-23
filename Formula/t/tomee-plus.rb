class TomeePlus < Formula
  desc "Everything in TomEE Web Profile and JAX-RS, plus more"
  homepage "https://tomee.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tomee/tomee-10.0.0/apache-tomee-10.0.0-plus.tar.gz"
  mirror "https://archive.apache.org/dist/tomee/tomee-10.0.0/apache-tomee-10.0.0-plus.tar.gz"
  sha256 "5f33aa1d0717d73fb1de84b0013f4b12ab76ba55f0d37ffe9267a20f3fbc4cfd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "98b4a55b38d8119fe3da0752d49addb26bbc26471be2a2a03929121fa363045c"
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
