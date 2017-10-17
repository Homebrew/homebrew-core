class StanfordParser < Formula
  desc "Statistical NLP parser"
  homepage "https://nlp.stanford.edu/software/lex-parser.shtml"
  url "https://nlp.stanford.edu/software/stanford-parser-full-2017-06-09.zip"
  version "3.8.0"
  sha256 "d03ed9a823c3001dde3069e96de25f322b7da12c4ea070b969e98ad467c4959f"

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
