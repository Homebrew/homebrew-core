class TomeePlume < Formula
  desc "Apache TomEE Plume"
  homepage "https://tomee.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tomee/tomee-9.1.2/apache-tomee-9.1.2-plume.tar.gz"
  mirror "https://archive.apache.org/dist/tomee/tomee-9.1.2/apache-tomee-9.1.2-plume.tar.gz"
  sha256 "4f734038f2557ba45bd4f00e17683ac15ad269f640b4aa7cbc13d16a61404c8c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "74b17fbec8b22ec641f46b1ecd0de49371e4c53071bb61dde96c52ca8492cda1"
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
    bin.install Dir["#{libexec}/bin/*.sh"]
    bin.env_script_all_files libexec/"bin", JAVA_HOME: Formula["openjdk"].opt_prefix
  end

  def caveats
    <<~EOS
      The home of Apache TomEE Plume is:
        #{opt_libexec}
      To run Apache TomEE:
        #{opt_bin}/startup.sh
    EOS
  end

  test do
    system "#{opt_bin}/configtest.sh"
  end
end
