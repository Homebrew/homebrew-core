class StanfordParser < Formula
  desc "Statistical NLP parser"
  homepage "http://nlp.stanford.edu/software/lex-parser.shtml"
  url "http://nlp.stanford.edu/software/stanford-parser-full-2015-12-09.zip"
  version "3.6.0"
  sha256 "b09ca9711d92004184c9212156f09d21f9af0d3e745e95d4c438b6ca1e4f950a"

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
