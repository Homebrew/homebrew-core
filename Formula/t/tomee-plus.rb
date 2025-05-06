class TomeePlus < Formula
  desc "Everything in TomEE Web Profile and JAX-RS, plus more"
  homepage "https://tomee.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tomee/tomee-10.0.1/apache-tomee-10.0.1-plus.tar.gz"
  mirror "https://archive.apache.org/dist/tomee/tomee-10.0.1/apache-tomee-10.0.1-plus.tar.gz"
  sha256 "b4520899aa8d5971d5be49b09b8622daafedf697ff321c8b3573b68a845661cf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "86778c7fb3c32585f2e9f3221d1bb7fffe9257553af38dbd9bfaacad36834fc0"
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
