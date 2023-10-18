class TomeeWebprofile < Formula
  desc "All-Apache Java EE 7 Web Profile stack"
  homepage "https://tomee.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tomee/tomee-9.1.1/apache-tomee-9.1.1-webprofile.tar.gz"
  mirror "https://archive.apache.org/dist/tomee/tomee-9.1.1/apache-tomee-9.1.1-webprofile.tar.gz"
  sha256 "77587e04eb960cd42cac099eb35934589c270a7548923c04e5e29bd2b029d538"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "77b527357ce9e075be683e8011d10c0b3fd3cf4aee1d84f3f6bb1fe056626a0f"
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
