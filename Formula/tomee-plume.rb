class TomeePlume < Formula
  desc "Apache TomEE Plume"
  homepage "https://tomee.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tomee/tomee-8.0.3/apache-tomee-8.0.3-plume.tar.gz"
  mirror "https://archive.apache.org/dist/tomee/tomee-8.0.3/apache-tomee-8.0.3-plume.tar.gz"
  sha256 "8d08324eed84e183f35911ef35020590668ee591e43678d34d2f8545c1a78883"
  license "Apache-2.0"

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

  def caveats
    <<~EOS
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
