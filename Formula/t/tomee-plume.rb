class TomeePlume < Formula
  desc "Apache TomEE Plume"
  homepage "https://tomee.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tomee/tomee-10.0.0/apache-tomee-10.0.0-plume.tar.gz"
  mirror "https://archive.apache.org/dist/tomee/tomee-10.0.0/apache-tomee-10.0.0-plume.tar.gz"
  sha256 "477159d9c5023bb2b01bbe06c56253cee592546df73d820be2e01198da450f1d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "24724e7b50140d24fd9644cbe942164933e70ca319d414d8e8656ee2e9c1b80c"
  end

  depends_on "openjdk"

  def install
    # Remove Windows scripts
    rm_r(Dir["bin/*.bat"])
    rm_r(Dir["bin/*.bat.original"])
    rm_r(Dir["bin/*.exe"])

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
