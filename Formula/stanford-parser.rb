class StanfordParser < Formula
  desc "Statistical NLP parser"
  homepage "https://nlp.stanford.edu/software/lex-parser.shtml"
  url "https://nlp.stanford.edu/software/stanford-parser-full-2018-02-27.zip"
  version "3.9.1"
  sha256 "c360eb294e52870a1df06878df65ed21c68145065d21f73c0028d717252a9bd7"

  bottle :unneeded

  depends_on :java => "1.8+"

  def install
    libexec.install Dir["*"]
    bin.write_exec_script Dir["#{libexec}/*.sh"]
  end

  test do
    system "#{bin}/lexparser.sh", "#{libexec}/data/testsent.txt"
  end
end
