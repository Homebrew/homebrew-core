class TomeeWebprofile < Formula
  desc "All-Apache Java EE 7 Web Profile stack"
  homepage "https://tomee.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tomee/tomee-8.0.0/apache-tomee-8.0.0-webprofile.tar.gz"
  mirror "https://archive.apache.org/dist/tomee/tomee-8.0.0/apache-tomee-8.0.0-webprofile.tar.gz"
  sha256 "5cdda0d0416700692f1e5282154f786f1fdb7015aa3909b0e44cdfe39720dedd"

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

  def caveats; <<~EOS
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
