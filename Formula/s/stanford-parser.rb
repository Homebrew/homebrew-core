class StanfordParser < Formula
  desc "Statistical NLP parser"
  homepage "https://nlp.stanford.edu/software/lex-parser.shtml"
  url "https://nlp.stanford.edu/software/stanford-parser-4.2.0.zip"
  sha256 "8c2110c78f7f82b66bcf91089a18e415669eda4346bbd9a6e3bc2bde63e5fed1"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?stanford-parser[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "699a16febb7fd2e483deaa44dee2fafbbe29d00343efe37d31d01d3b0fa14fe1"
  end

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    bin.install Dir["#{libexec}/*.sh"]
    bin.env_script_all_files libexec, JAVA_HOME: Formula["openjdk"].opt_prefix
  end

  test do
    system bin/"lexparser.sh", libexec/"data/english-onesent.txt"
  end
end
