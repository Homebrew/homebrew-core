class TomeePlume < Formula
  desc "Apache TomEE Plume"
  homepage "https://tomee.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tomee/tomee-8.0.13/apache-tomee-8.0.13-plume.tar.gz"
  mirror "https://archive.apache.org/dist/tomee/tomee-8.0.13/apache-tomee-8.0.13-plume.tar.gz"
  sha256 "94bc0347849fcb9c10407a6e0177ac4304ce54d803528e6f4716c02090ab384e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f46866db42983b924da50d464240efd1fd6602fd463b616af08abc01613e3ac3"
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
