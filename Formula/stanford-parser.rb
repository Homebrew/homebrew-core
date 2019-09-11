class StanfordParser < Formula
  desc "Statistical NLP parser"
  homepage "https://nlp.stanford.edu/software/lex-parser.shtml"
  url "https://nlp.stanford.edu/software/stanford-parser-full-2018-10-17.zip"
  version "3.9.2"
  sha256 "92d852af54c0727c2367b9ce267c53bf08f1551a08ec5dd92c357b8cc7b2bcd9"

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
