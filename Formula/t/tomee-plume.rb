class TomeePlume < Formula
  desc "Apache TomEE Plume"
  homepage "https://tomee.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tomee/tomee-10.1.2/apache-tomee-10.1.2-plume.tar.gz"
  mirror "https://archive.apache.org/dist/tomee/tomee-10.1.2/apache-tomee-10.1.2-plume.tar.gz"
  sha256 "58066f8da82c4b9194a579dd31f55e0ba7bd08fe073fe1defd86f60b89c41b4c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ed1c3f847d659c083921f778db78ee3a18900621f5529473bdfd8335cd8b6f1c"
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
