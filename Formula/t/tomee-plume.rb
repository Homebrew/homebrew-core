class TomeePlume < Formula
  desc "Apache TomEE Plume"
  homepage "https://tomee.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tomee/tomee-9.1.1/apache-tomee-9.1.1-plume.tar.gz"
  mirror "https://archive.apache.org/dist/tomee/tomee-9.1.1/apache-tomee-9.1.1-plume.tar.gz"
  sha256 "f7679ddaa7d9c544f250f88cd5cec6de717903fdfa76618702a20ef83072f210"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "dfe32167fa31648fdcc3a1e980700abdf02f6f812cf63b5b0fb68f2451e718ca"
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
