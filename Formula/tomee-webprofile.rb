class TomeeWebprofile < Formula
  desc "All-Apache Java EE 7 Web Profile stack"
  homepage "https://tomee.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tomee/tomee-8.0.10/apache-tomee-8.0.10-webprofile.tar.gz"
  mirror "https://archive.apache.org/dist/tomee/tomee-8.0.10/apache-tomee-8.0.10-webprofile.tar.gz"
  sha256 "8886682389b5b4c53b127e3876ce5837b4a3a40cd7243751ae126fcf42d0b951"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "491e32a197c4274a3a8a68893dcc871d827d4fc2ab5212631d57aaddedd0b234"
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
