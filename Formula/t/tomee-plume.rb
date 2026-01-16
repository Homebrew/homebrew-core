class TomeePlume < Formula
  desc "Apache TomEE Plume"
  homepage "https://tomee.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tomee/tomee-10.1.3/apache-tomee-10.1.3-plume.tar.gz"
  mirror "https://archive.apache.org/dist/tomee/tomee-10.1.3/apache-tomee-10.1.3-plume.tar.gz"
  sha256 "cc893c816adb5c58addae198869b2189cd9e8e698c0176ba30cc985606dfbd2b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c6bc575cce93b455c1812a048d6fd5e453ebc9406afca2e4aa595e216de64bcc"
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
