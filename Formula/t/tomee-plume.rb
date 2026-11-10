class TomeePlume < Formula
  desc "Apache TomEE Plume"
  homepage "https://tomee.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tomee/tomee-10.3.0/apache-tomee-10.3.0-plume.tar.gz"
  mirror "https://archive.apache.org/dist/tomee/tomee-10.3.0/apache-tomee-10.3.0-plume.tar.gz"
  sha256 "8aee5cb91fd2f952ceee9d189c9c3930f1838e4f07b1ecc85c1af3a38c66d81d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f8533a89d6795ea62436891a41ec921d19c88d4d12ae0c3b8b4029cb1efcd071"
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
    bin.env_script_all_files libexec/"bin", JAVA_HOME: formula_opt_prefix("openjdk")
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
