class Redpen < Formula
  desc "Proofreading tool to help writers of technical documentation"
  homepage "https://redpen.cc/"
  url "https://github.com/redpen-cc/redpen/releases/download/redpen-1.10.4/redpen-1.10.4.tar.gz"
  sha256 "6c3dc4a6a45828f9cc833ca7253fdb036179036631248288251cb9ac4520c39d"

  bottle :unneeded

  depends_on "openjdk"

  def install
    # Don't need Windows files.
    rm_f Dir["bin/*.bat"]
    libexec.install %w[conf lib sample-doc js]

    prefix.install "bin"
    bin.env_script_all_files libexec/"bin", :JAVA_HOME => Formula["openjdk"].opt_prefix
  end

  test do
    path = "#{libexec}/sample-doc/en/sampledoc-en.txt"
    output = "#{bin}/redpen -l 20 -c #{libexec}/conf/redpen-conf-en.xml #{path}"
    match = /sampledoc-en.txt:1: ValidationError[SentenceLength]*/
    assert_match match, shell_output(output).split("\n").select { |line| line.include?("sampledoc-en.txt") }[0]
  end
end
