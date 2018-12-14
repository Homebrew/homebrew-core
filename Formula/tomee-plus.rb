class TomeePlus < Formula
  desc "Everything in TomEE Web Profile and JAX-RS, plus more"
  homepage "https://tomee.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=tomee/tomee-1.7.5/apache-tomee-1.7.5-plus.tar.gz"
  sha256 "d7e1f8aff94151928149042b2938287c7148cc002d0e953452eb51a82a952a15"

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

  def caveats; <<~EOS
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
