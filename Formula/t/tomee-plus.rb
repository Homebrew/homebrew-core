class TomeePlus < Formula
  desc "Everything in TomEE Web Profile and JAX-RS, plus more"
  homepage "https://tomee.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tomee/tomee-9.1.2/apache-tomee-9.1.2-plus.tar.gz"
  mirror "https://archive.apache.org/dist/tomee/tomee-9.1.2/apache-tomee-9.1.2-plus.tar.gz"
  sha256 "8e6c7cc8e21798529286bb8b4fb9875ea20f2194ddc084c3f2847a4b6086e950"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0c5a8f56ded95a6d7f6d10ab1a3c2d0666941f28872d5cad2d84b3d40bd2b579"
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
