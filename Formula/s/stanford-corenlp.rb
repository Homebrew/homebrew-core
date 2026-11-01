class StanfordCorenlp < Formula
  desc "Java suite of core NLP tools"
  homepage "https://stanfordnlp.github.io/CoreNLP/"
  url "https://huggingface.co/stanfordnlp/CoreNLP/resolve/v4.6.0/stanford-corenlp-latest.zip"
  sha256 "761ed3020fcfd3e05222848d4240fa7029459e7efcf01f1c01e381cc0a3be597"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?stanford-corenlp[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "57e09b9b366bf5c0ffc54a90d1b933dd4c9de88af2a5d3958322dd3a1e5c76a4"
  end

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    bin.install Dir["#{libexec}/*.sh"]
    bin.env_script_all_files libexec, JAVA_HOME: formula_opt_prefix("openjdk")
  end

  test do
    (testpath/"test.txt").write("Stanford is a university, founded in 1891.")
    system bin/"corenlp.sh", "-annotators tokenize,ssplit,pos", "-file test.txt", "-outputFormat json"
    assert_path_exists (testpath/"test.txt.json")
  end
end
