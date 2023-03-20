class TomeeWebprofile < Formula
  desc "All-Apache Java EE 7 Web Profile stack"
  homepage "https://tomee.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tomee/tomee-9.0.0/apache-tomee-9.0.0-webprofile.tar.gz"
  mirror "https://archive.apache.org/dist/tomee/tomee-9.0.0/apache-tomee-9.0.0-webprofile.tar.gz"
  sha256 "bd2490ef348f757d00fbfd96fee5584eaadf9886d3b0b56c1aac24482469def2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c140be26b21debf6a7014497477074ec401053299e04133eb3130d9d387ce47e"
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
