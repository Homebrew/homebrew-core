class TomeePlume < Formula
  desc "Apache TomEE Plume"
  homepage "https://tomee.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tomee/tomee-10.1.0/apache-tomee-10.1.0-plume.tar.gz"
  mirror "https://archive.apache.org/dist/tomee/tomee-10.1.0/apache-tomee-10.1.0-plume.tar.gz"
  sha256 "af98bb741af54a8824eb0f7e21c468a77de693d0189931717c6f0e7fb77f8ef4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "06e8bd164ab4e7888694aa322e493284918ae3092d7d5b59b36bb19918955854"
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
