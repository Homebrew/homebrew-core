class StanfordCorenlp < Formula
  desc "Java suite of core NLP tools"
  homepage "https://stanfordnlp.github.io/CoreNLP/"
  url "https://nlp.stanford.edu/software/stanford-corenlp-4.3.1.zip"
  sha256 "d21ec1dfc2f2888cffd8a0fcb47cb5d899ec518fe1f28d902819065d16511424"
  license "GPL-2.0-or-later"

  # The first-party website only links to an unversioned archive file from
  # nlp.stanford.edu (stanford-corenlp-latest.zip), so we match the version
  # in the Maven link instead.
  livecheck do
    url :homepage
    regex(%r{href=.*?/stanford-corenlp/v?(\d+(?:\.\d+)+)/jar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b1aef7cf97ac8eb8d3bf5dfde284ebf5ea812343217c27caa9ef2a051b87606c"
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
