class Redpen < Formula
  desc "Proofreading tool to help writers of technical documentation"
  homepage "http://redpen.cc/"
  url "https://github.com/redpen-cc/redpen/archive/redpen-1.10.3.tar.gz"
  sha256 "5a75d164591726d04027b30e6d3f82a7f59aadd83e1a315377d85f5a71343cef"

  bottle :unneeded

  depends_on :java => "1.8+"

  def install
    # Don't need Windows files.
    rm_f Dir["bin/*.bat"]
    libexec.install %w[conf lib sample-doc js]

    prefix.install "bin"
    bin.env_script_all_files(libexec/"bin", Language::Java.java_home_env("1.8+"))
  end

  test do
    path = "#{libexec}/sample-doc/en/sampledoc-en.txt"
    output = "#{bin}/redpen -l 20 -c #{libexec}/conf/redpen-conf-en.xml #{path}"
    match = /^sampledoc-en.txt:1: ValidationError[SymbolWithSpace]*/
    assert_match match, shell_output(output).split("\n").select { |line| line.start_with?("sampledoc-en.txt") }[0]
  end
end
