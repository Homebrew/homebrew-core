class StanfordCorenlp < Formula
  desc "Java suite of core NLP tools"
  homepage "https://stanfordnlp.github.io/CoreNLP/"
  url "https://nlp.stanford.edu/software/stanford-corenlp-4.4.0.zip"
  sha256 "c04b07e8b539a00c0816f183ed1f55b79041641f5422fe943829fdabbee67e47"
  license "GPL-2.0-or-later"

  # The first-party website only links to an unversioned archive file from
  # nlp.stanford.edu (stanford-corenlp-latest.zip), so we match the version
  # in the Maven link instead.
  livecheck do
    url :homepage
    regex(%r{href=.*?/stanford-corenlp/v?(\d+(?:\.\d+)+)/jar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6fd51a09939a5a8f42a65ddf821319894d5d9a754026426ef8b8fc56a88e0860"
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
