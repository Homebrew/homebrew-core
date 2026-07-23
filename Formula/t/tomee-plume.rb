class TomeePlume < Formula
  desc "Apache TomEE Plume"
  homepage "https://tomee.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tomee/tomee-10.2.0/apache-tomee-10.2.0-plume.tar.gz"
  mirror "https://archive.apache.org/dist/tomee/tomee-10.2.0/apache-tomee-10.2.0-plume.tar.gz"
  sha256 "35a3debe0eb845b063f6f68c633bd14365a35f0c689d0780b1832c39bc83a78e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4fcfa827e29a8a572710586782997f095e1e2219de5cecd7124c2d8d25c96952"
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
