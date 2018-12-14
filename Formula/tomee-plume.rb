class TomeePlume < Formula
  desc "Apache TomEE Plume"
  homepage "https://tomee.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=tomee/tomee-1.7.5/apache-tomee-1.7.5-plume.tar.gz"
  sha256 "948955232f6b1f4ecbf227e793a61fc8a467771c00980c44fb36e6e57c4691e1"

  bottle :unneeded

  def install
    # Remove Windows scripts
    rm_rf Dir["bin/*.bat"]
    rm_rf Dir["bin/*.bat.original"]
    rm_rf Dir["bin/*.exe"]

    # Install files
    prefix.install %w[NOTICE LICENSE RELEASE-NOTES RUNNING.txt]
    libexec.install Dir["*"]
    bin.install_symlink "#{libexec}/bin/startup.sh" => "tomee-plume-startup"
  end

  def caveats; <<~EOS
    The home of Apache TomEE Plume is:
      #{opt_libexec}
    To run Apache TomEE:
      #{opt_libexec}/bin/tomee-plume-startup
  EOS
  end

  test do
    system "#{opt_libexec}/bin/configtest.sh"
  end
end
