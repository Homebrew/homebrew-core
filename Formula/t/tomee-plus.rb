class TomeePlus < Formula
  desc "Everything in TomEE Web Profile and JAX-RS, plus more"
  homepage "https://tomee.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tomee/tomee-10.3.0/apache-tomee-10.3.0-plus.tar.gz"
  mirror "https://archive.apache.org/dist/tomee/tomee-10.3.0/apache-tomee-10.3.0-plus.tar.gz"
  sha256 "d9d8295302d2c2ddedec073c4b4b013fecdc502d272a41a9836ba0ed35ded4f7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "895e5683342ab5a110bfa94b210ac663ba94ee05108e2e9b7381384b4f671bb1"
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
    ENV["JAVA_HOME"] = formula_opt_prefix("openjdk")
    system "#{opt_libexec}/bin/configtest.sh"
  end
end
