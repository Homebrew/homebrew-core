class Redpen < Formula
  desc "Proofreading tool to help writers of technical documentation"
  homepage "https://redpen.cc/"
  url "https://github.com/redpen-cc/redpen/releases/download/redpen-1.10.4/redpen-1.10.4.tar.gz"
  sha256 "6c3dc4a6a45828f9cc833ca7253fdb036179036631248288251cb9ac4520c39d"
  license "Apache-2.0"
  revision 2

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/(?:redpen[._-])?v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f782eba6bcc7fc6d4824b17538b279485410c8cf0d78b55d314c293c4d956d92"
  end

  depends_on "openjdk@11"

  def install
    # Don't need Windows files.
    rm_f Dir["bin/*.bat"]
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
