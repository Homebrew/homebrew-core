class TomeePlume < Formula
  desc "Apache TomEE Plume"
  homepage "https://tomee.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tomee/tomee-8.0.12/apache-tomee-8.0.12-plume.tar.gz"
  mirror "https://archive.apache.org/dist/tomee/tomee-8.0.12/apache-tomee-8.0.12-plume.tar.gz"
  sha256 "3e3c9937b1e26ced4db5eb356e683131e3f4c0cc01ddc2ef3b460d30e2208e53"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "dad8ba85ad7e1ba9c55b482ffcf1f8a9b8642979f5abf2816be9dfcb97c7015e"
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
