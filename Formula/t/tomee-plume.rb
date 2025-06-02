class TomeePlume < Formula
  desc "Apache TomEE Plume"
  homepage "https://tomee.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tomee/tomee-10.0.1/apache-tomee-10.0.1-plume.tar.gz"
  mirror "https://archive.apache.org/dist/tomee/tomee-10.0.1/apache-tomee-10.0.1-plume.tar.gz"
  sha256 "4162c99c5f4466d641b7aed2807fb691a565d43cbe44c1c65defdda216030e90"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1d13c509f4300cb3d5a1c2ede28dacfa519bf5f53c0a71063b2d8cfdb936e782"
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
