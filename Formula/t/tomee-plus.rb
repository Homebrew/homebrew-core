class TomeePlus < Formula
  desc "Everything in TomEE Web Profile and JAX-RS, plus more"
  homepage "https://tomee.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tomee/tomee-10.1.0/apache-tomee-10.1.0-plus.tar.gz"
  mirror "https://archive.apache.org/dist/tomee/tomee-10.1.0/apache-tomee-10.1.0-plus.tar.gz"
  sha256 "4e181157d9a512b4c7886ff3f9054cee5f20cf90b1203b91defa4619eb988702"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b9e9c9d9caf5cb8ee0cabb7ab09a967bb0bf6fbac5442dedcf7cd5e79b65bf6d"
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
