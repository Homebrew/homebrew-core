class TomeePlume < Formula
  desc "Apache TomEE Plume"
  homepage "https://tomee.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tomee/tomee-9.1.3/apache-tomee-9.1.3-plume.tar.gz"
  mirror "https://archive.apache.org/dist/tomee/tomee-9.1.3/apache-tomee-9.1.3-plume.tar.gz"
  sha256 "2ca7033ece4e869ea88061248a1a2a6eeb4081720b2a6b82afadfe9eef72c856"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e3f044fd87a63704057a7061de7c8d73cc8e859bf246f9497c15b221b0414643"
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
