class StanfordCorenlp < Formula
  desc "Java suite of core NLP tools"
  homepage "https://stanfordnlp.github.io/CoreNLP/"
  url "https://nlp.stanford.edu/software/stanford-corenlp-full-2018-10-05.zip"
  version "3.9.2"
  sha256 "833f0f5413a33e7fbc98aeddcb80eb0a55b672f67417b8d956ed9c39abe8d26c"

  bottle :unneeded

  depends_on :java => "1.8+"

  def install
    libexec.install Dir["*"]
    bin.write_exec_script Dir["#{libexec}/*.sh"]
  end

  test do
    (testpath/"test.txt").write("Stanford is a university, founded in 1891.")
    system "#{bin}/corenlp.sh", "-annotators tokenize,ssplit,pos", "-file test.txt"
    assert_predicate (testpath/"test.txt.xml"), :exist?
  end
end
