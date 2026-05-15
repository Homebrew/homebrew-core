class TomeePlume < Formula
  desc "Apache TomEE Plume"
  homepage "https://tomee.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tomee/tomee-10.1.5/apache-tomee-10.1.5-plume.tar.gz"
  mirror "https://archive.apache.org/dist/tomee/tomee-10.1.5/apache-tomee-10.1.5-plume.tar.gz"
  sha256 "d6e8c87766d3b3b7bcec6db8d5141e61fe8275d6bce1775701762ad021ae66c5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1da6fae7a8b040565c7cb355a5dc58e34b7ccf675770bb53ccac66f3c5bfeea1"
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
