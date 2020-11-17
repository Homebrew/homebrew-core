class Reposurgeon < Formula
  desc "Edit version-control repository history"
  homepage "http://www.catb.org/esr/reposurgeon/"
  url "https://gitlab.com/esr/reposurgeon.git",
    tag:      "4.20",
    revision: "2470b8199c043a2710d6ef2c29767594509785d9"
  license "BSD-2-Clause"
  head "https://gitlab.com/esr/reposurgeon.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "62a870e757aca026be8fa1bffcfb7551160b2cc7ad46d615002c0563611de4be" => :big_sur
    sha256 "54257b991eca3725c03ed737d38158f2c9406b29fe035ed43a59dda6ac0400d2" => :catalina
    sha256 "045b3d231e384da1ac603b3f7f4d0b96b86bccfb208e93148aa56fee0d7baffa" => :mojave
    sha256 "b1025a09b10689b8562959ed6e6e37c77d04765285ba64fde51bbf385e15ff29" => :high_sierra
  end

  depends_on "asciidoctor" => :build
  depends_on "go" => :build
  depends_on "git" # requires >= 2.19.2

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    system "make"
    system "make", "install", "prefix=#{prefix}"
    elisp.install "reposurgeon-mode.el"
  end

  test do
    (testpath/".gitconfig").write <<~EOS
      [user]
        name = Real Person
        email = notacat@hotmail.cat
    EOS
    system "git", "init"
    system "git", "commit", "--allow-empty", "--message", "brewing"

    assert_match "brewing",
      shell_output("script -q /dev/null #{bin}/reposurgeon read list")
  end
end
