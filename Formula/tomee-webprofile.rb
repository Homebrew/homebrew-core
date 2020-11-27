class TomeeWebprofile < Formula
  desc "All-Apache Java EE 7 Web Profile stack"
  homepage "https://tomee.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tomee/tomee-8.0.5/apache-tomee-8.0.5-webprofile.tar.gz"
  mirror "https://archive.apache.org/dist/tomee/tomee-8.0.5/apache-tomee-8.0.5-webprofile.tar.gz"
  sha256 "51deb024888fa5b7ef169c07f0d3bc43c13f9e8e7d00bf07d1f6f0cfaaeb7d88"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle :unneeded

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
        JAVA_HOME: Formula["openjdk"].opt_prefix
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
