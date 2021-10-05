class TomeePlume < Formula
  desc "Apache TomEE Plume"
  homepage "https://tomee.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tomee/tomee-8.0.8/apache-tomee-8.0.8-plume.tar.gz"
  mirror "https://archive.apache.org/dist/tomee/tomee-8.0.8/apache-tomee-8.0.8-plume.tar.gz"
  sha256 "396e92760483ac871a446219fa7f35b01927e4bea41bc9d922d0211bb526913b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "294874e4a0a67698eee66b53f2eb4f7ab6af92d82b5130335b4b3797bf17a516"
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
