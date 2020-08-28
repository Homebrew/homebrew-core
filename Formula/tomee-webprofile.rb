class TomeeWebprofile < Formula
  desc "All-Apache Java EE 7 Web Profile stack"
  homepage "https://tomee.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tomee/tomee-8.0.3/apache-tomee-8.0.3-webprofile.tar.gz"
  mirror "https://archive.apache.org/dist/tomee/tomee-8.0.3/apache-tomee-8.0.3-webprofile.tar.gz"
  sha256 "ff9921913c0a6e24514a139703db066e90d2e51c37cfde948595c7d5d5e4168b"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle :unneeded

  def install
    # Remove Windows scripts
    rm_rf Dir["bin/*.bat"]
    rm_rf Dir["bin/*.bat.original"]
    rm_rf Dir["bin/*.exe"]

    # Install files
    prefix.install %w[NOTICE LICENSE RELEASE-NOTES RUNNING.txt]
    libexec.install Dir["*"]
    bin.install_symlink "#{libexec}/bin/startup.sh" => "tomee-webprofile-startup"
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
    system "#{opt_libexec}/bin/configtest.sh"
  end
end
