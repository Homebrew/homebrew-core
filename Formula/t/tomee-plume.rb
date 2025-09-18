class TomeePlume < Formula
  desc "Apache TomEE Plume"
  homepage "https://tomee.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tomee/tomee-10.1.1/apache-tomee-10.1.1-plume.tar.gz"
  mirror "https://archive.apache.org/dist/tomee/tomee-10.1.1/apache-tomee-10.1.1-plume.tar.gz"
  sha256 "ca38ca6c711fff5eea5c655f786a76dc30286ea809c6f09ac5346e838818369e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "88ebb160cea90ae63de42b759659ef275412993cf8e40ef1d37bc6c5aae079ff"
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
