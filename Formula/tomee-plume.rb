class TomeePlume < Formula
  desc "Apache TomEE Plume"
  homepage "https://tomee.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tomee/tomee-9.1.0/apache-tomee-9.1.0-plume.tar.gz"
  mirror "https://archive.apache.org/dist/tomee/tomee-9.1.0/apache-tomee-9.1.0-plume.tar.gz"
  sha256 "39de1acf4a2490299a2e9f9e94cad2813ce8022581c577ea854a0930b5f59b5b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ed9c3bd1890b1fdaef25e22914aebfaf7e23188c70febd9a20f77f1bec8540c0"
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
