class TomeePlume < Formula
  desc "Apache TomEE Plume"
  homepage "https://tomee.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tomee/tomee-10.1.4/apache-tomee-10.1.4-plume.tar.gz"
  mirror "https://archive.apache.org/dist/tomee/tomee-10.1.4/apache-tomee-10.1.4-plume.tar.gz"
  sha256 "13b800fd8ba99497d5e42aa19b17842f61d183c8497128bbc1ec221b5e1139ae"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "575a84d9845dcf7ce10f7e962cae2c77a1a9d8b8e771bf7a05a7475bb41f27c9"
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
