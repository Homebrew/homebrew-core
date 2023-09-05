class TomeeWebprofile < Formula
  desc "All-Apache Java EE 7 Web Profile stack"
  homepage "https://tomee.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tomee/tomee-9.1.0/apache-tomee-9.1.0-webprofile.tar.gz"
  mirror "https://archive.apache.org/dist/tomee/tomee-9.1.0/apache-tomee-9.1.0-webprofile.tar.gz"
  sha256 "bb30d058f683c6b0af2d19368b0985aba6ccf72cd7da175200878ed83be6e9ca"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b128413ddae87ffba0e09885ed5ce25fa9be5230ba0562037875be1424c94aa8"
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
