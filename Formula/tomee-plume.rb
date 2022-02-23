class TomeePlume < Formula
  desc "Apache TomEE Plume"
  homepage "https://tomee.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tomee/tomee-8.0.10/apache-tomee-8.0.10-plume.tar.gz"
  mirror "https://archive.apache.org/dist/tomee/tomee-8.0.10/apache-tomee-8.0.10-plume.tar.gz"
  sha256 "c0ac9b9f28720c1a0d8e412a18c26e62f06e344ba3c713ee26acafc3db873611"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d417c94d915ac9ebf233e64b59f815319b2f8d8e114b321747762b1112c4bd7f"
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
