class TomeeWebprofile < Formula
  desc "All-Apache Java EE 7 Web Profile stack"
  homepage "https://tomee.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tomee/tomee-9.1.3/apache-tomee-9.1.3-webprofile.tar.gz"
  mirror "https://archive.apache.org/dist/tomee/tomee-9.1.3/apache-tomee-9.1.3-webprofile.tar.gz"
  sha256 "290fac8a265e48d73d4733dc68a78ed52e037de6dfa053106f2710cae4b1ff08"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "90afe6c29951f0a927226bd37fe725447ff3d09febfab263012d7c8bdf992101"
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
    (bin/"tomee-webprofile-startup").write_env_script "#{libexec}/bin/startup.sh",
                                                      Language::Java.overridable_java_home_env
  end

  def caveats
    <<~EOS
      The home of Apache TomEE Web is:
        #{opt_libexec}
      To run Apache TomEE:
        #{opt_libexec}/bin/tomee-webprofile-startup
    EOS
  end

  test do
    ENV["JAVA_HOME"] = Formula["openjdk"].opt_prefix
    system "#{opt_libexec}/bin/configtest.sh"
  end
end
