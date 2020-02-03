class StanfordCorenlp < Formula
  desc "Java suite of core NLP tools"
  homepage "https://stanfordnlp.github.io/CoreNLP/"
  url "https://nlp.stanford.edu/software/stanford-corenlp-full-2018-10-05.zip"
  version "3.9.2"
  sha256 "833f0f5413a33e7fbc98aeddcb80eb0a55b672f67417b8d956ed9c39abe8d26c"
  revision 1

  bottle :unneeded

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    bin.install Dir["#{libexec}/*.sh"]
    bin.env_script_all_files libexec, :JAVA_HOME => Formula["openjdk"].opt_prefix
  end

  test do
    (testpath/"test.txt").write("Stanford is a university, founded in 1891.")
    system "#{bin}/corenlp.sh", "-annotators tokenize,ssplit,pos", "-file test.txt"
    assert_predicate (testpath/"test.txt.xml"), :exist?
  end
end
