class Redpen < Formula
  desc "Proofreading tool to help writers of technical documentation"
  homepage "https://redpen.cc/"
  url "https://github.com/redpen-cc/redpen/releases/download/redpen-1.10.4/redpen-1.10.4.tar.gz"
  sha256 "6c3dc4a6a45828f9cc833ca7253fdb036179036631248288251cb9ac4520c39d"
  license "Apache-2.0"
  revision 2

  livecheck do
    url :stable
    regex(/(?:redpen[._-])?v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "06d9d1562bd8c00de7be8ad87e1bb69494deb932496dcd2d2b9dc2aebb87ddd1"
  end

  depends_on "openjdk@11"

  def install
    # Don't need Windows files.
    rm(Dir["bin/*.bat"])
    libexec.install %w[conf lib sample-doc js]

    prefix.install "bin"
    env = Language::Java.java_home_env("11")
    env["PATH"] = "$JAVA_HOME/bin:$PATH"
    bin.env_script_all_files libexec/"bin", env
  end

  test do
    path = "#{libexec}/sample-doc/en/sampledoc-en.txt"
    output = "#{bin}/redpen -l 20 -c #{libexec}/conf/redpen-conf-en.xml #{path}"
    match = "sampledoc-en.txt:1: ValidationError[SentenceLength]"
    assert_match match, shell_output(output).split("\n").find { |line| line.include?("sampledoc-en.txt") }
  end
end
