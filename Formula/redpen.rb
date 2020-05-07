class Redpen < Formula
  desc "Proofreading tool to help writers of technical documentation"
  homepage "https://redpen.cc/"
  url "https://github.com/redpen-cc/redpen/releases/download/redpen-1.10.3/redpen-1.10.3.tar.gz"
  sha256 "0a7543e3961428ce68eb47c964e8988ec2f585db6e32ded582eb6626a98ffdd2"
  revision 1

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
    match = /^sampledoc-en.txt:1: ValidationError[SymbolWithSpace]*/
    assert_match match, shell_output(output).split("\n").select { |line| line.start_with?("sampledoc-en.txt") }[0]
  end
end
