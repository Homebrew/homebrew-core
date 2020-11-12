class TomeeWebprofile < Formula
  desc "All-Apache Java EE 7 Web Profile stack"
  homepage "https://tomee.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tomee/tomee-8.0.4/apache-tomee-8.0.4-webprofile.tar.gz"
  mirror "https://archive.apache.org/dist/tomee/tomee-8.0.4/apache-tomee-8.0.4-webprofile.tar.gz"
  sha256 "13b0817a17e54069c39c3878d7a271b52fe5adceb6ddef3fe1147f2cea2d78ac"
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
