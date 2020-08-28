class TomeePlus < Formula
  desc "Everything in TomEE Web Profile and JAX-RS, plus more"
  homepage "https://tomee.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tomee/tomee-8.0.4/apache-tomee-8.0.4-plus.tar.gz"
  mirror "https://archive.apache.org/dist/tomee/tomee-8.0.4/apache-tomee-8.0.4-plus.tar.gz"
  sha256 "5837e910f6095524ba9d31b0e78dc77779f4f1477c153df85263d8009bda06b8"
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
    bin.install_symlink "#{libexec}/bin/startup.sh" => "tomee-plus-startup"
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
    system "#{opt_libexec}/bin/configtest.sh"
  end
end
