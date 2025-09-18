class TomeePlus < Formula
  desc "Everything in TomEE Web Profile and JAX-RS, plus more"
  homepage "https://tomee.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tomee/tomee-10.1.1/apache-tomee-10.1.1-plus.tar.gz"
  mirror "https://archive.apache.org/dist/tomee/tomee-10.1.1/apache-tomee-10.1.1-plus.tar.gz"
  sha256 "5563cffd7777df4e30575d3e3a27cb964fac1b7c010209cb0e23153e49f6f68d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d9b2248f26dc03fd07126444f7cc775843329061e9cfdb7ba6d39e4780371ccf"
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
