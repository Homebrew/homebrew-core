class TomeePlus < Formula
  desc "Everything in TomEE Web Profile and JAX-RS, plus more"
  homepage "https://tomee.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tomee/tomee-9.1.0/apache-tomee-9.1.0-plus.tar.gz"
  mirror "https://archive.apache.org/dist/tomee/tomee-9.1.0/apache-tomee-9.1.0-plus.tar.gz"
  sha256 "8de618304e261cbefdb30c59516c9cef3417df67f07fa857eab636c662d874a7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "89a2bc95dda06b9cd3486b35ab7bed3d05bfeba0458ad4c59b62e65644c73676"
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
