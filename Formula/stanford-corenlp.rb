class StanfordCorenlp < Formula
  desc "Java suite of core NLP tools"
  homepage "https://stanfordnlp.github.io/CoreNLP/"
  url "https://nlp.stanford.edu/software/stanford-corenlp-4.2.2.zip"
  sha256 "42f0bd84b815b15658a17aeabe5ab8c5ba1d4e5a3785969fe7be8588209f02cc"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?stanford-corenlp[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e1580a6e899a81fa4ff31dc192521b9fe028b8612a2973a9935b3578e999c89e"
  end

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    bin.install Dir["#{libexec}/*.sh"]
    bin.env_script_all_files libexec, JAVA_HOME: Formula["openjdk"].opt_prefix
  end

  test do
    (testpath/"test.txt").write("Stanford is a university, founded in 1891.")
    system "#{bin}/corenlp.sh", "-annotators tokenize,ssplit,pos", "-file test.txt", "-outputFormat json"
    assert_predicate (testpath/"test.txt.json"), :exist?
  end
end
