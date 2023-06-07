class TomeePlume < Formula
  desc "Apache TomEE Plume"
  homepage "https://tomee.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tomee/tomee-9.0.0/apache-tomee-9.0.0-plume.tar.gz"
  mirror "https://archive.apache.org/dist/tomee/tomee-9.0.0/apache-tomee-9.0.0-plume.tar.gz"
  sha256 "6fc93289536edcba09cc1ad38d045a88acff9330198e755043960d9a3e2190e6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a1d324faeeeca5c81b7654bd1584fa25cbee3cfcf7b4bd66fa20fa28c48e7797"
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
