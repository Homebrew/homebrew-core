class TomeeJaxRs < Formula
  desc "TomeEE Web Profile plus JAX-RS"
  homepage "https://tomee.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=tomee/tomee-1.7.5/apache-tomee-1.7.5-jaxrs.tar.gz"
  sha256 "5c9241ca683db85c13a23234b206fe98011d734a661383bbc9027deb756c09da"

  bottle :unneeded

  def install
    # Remove Windows scripts
    rm_rf Dir["bin/*.bat"]
    rm_rf Dir["bin/*.bat.original"]
    rm_rf Dir["bin/*.exe"]

    # Install files
    prefix.install %w[NOTICE LICENSE RELEASE-NOTES RUNNING.txt]
    libexec.install Dir["*"]
    bin.install_symlink "#{libexec}/bin/startup.sh" => "tomee-jax-rs-startup"
  end

  def caveats; <<~EOS
    The home of Apache TomEE JAX-RS is:
      #{opt_libexec}
    To run Apache TomEE:
      #{opt_libexec}/bin/tomee-jax-rs-startup
  EOS
  end

  test do
    system "#{opt_libexec}/bin/configtest.sh"
  end
end
