class TomeePlume < Formula
  desc "Apache TomEE Plume"
  homepage "https://tomee.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tomee/tomee-8.0.9/apache-tomee-8.0.9-plume.tar.gz"
  mirror "https://archive.apache.org/dist/tomee/tomee-8.0.9/apache-tomee-8.0.9-plume.tar.gz"
  sha256 "2e83d8d040519b0a5c16e75058493a1478c04f41a15f2d10cc853d0480ece303"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d6dc52735387b04df2df5684ac39b013e378e3e89fae9c78a889a9023e856f8a"
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
