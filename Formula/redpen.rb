class Redpen < Formula
  desc "Proofreading tool to help writers of technical documentation"
  homepage "https://redpen.cc/"
  url "https://github.com/redpen-cc/redpen/releases/download/redpen-1.10.4/redpen-1.10.4.tar.gz"
  sha256 "6c3dc4a6a45828f9cc833ca7253fdb036179036631248288251cb9ac4520c39d"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/(?:redpen[._-])?v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a64e713c28e2030248d5bca045bbda57f33c876de674a89d6f9585101b570587"
  end

  depends_on "openjdk@11"

  def install
    # Don't need Windows files.
    rm_f Dir["bin/*.bat"]
    libexec.install %w[conf lib sample-doc js]

    prefix.install "bin"
    bin.env_script_all_files libexec/"bin", JAVA_HOME: Formula["openjdk@11"].opt_prefix
  end

  test do
    path = "#{libexec}/sample-doc/en/sampledoc-en.txt"
    output = "#{bin}/redpen -l 20 -c #{libexec}/conf/redpen-conf-en.xml #{path}"
    match = "sampledoc-en.txt:1: ValidationError[SentenceLength]"
    assert_match match, shell_output(output).split("\n").find { |line| line.include?("sampledoc-en.txt") }
  end
end
