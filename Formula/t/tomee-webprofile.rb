class TomeeWebprofile < Formula
  desc "All-Apache Java EE 7 Web Profile stack"
  homepage "https://tomee.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tomee/tomee-10.0.1/apache-tomee-10.0.1-webprofile.tar.gz"
  mirror "https://archive.apache.org/dist/tomee/tomee-10.0.1/apache-tomee-10.0.1-webprofile.tar.gz"
  sha256 "43edd2b6ea5c0aabd8a74725064d9caa6dbddd729db8888d06a1d209a5da4d1b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e258bd58ba77c24dd8f5f634c03be8cfaa32462baece64356c979377db184226"
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
