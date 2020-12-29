class Reposurgeon < Formula
  desc "Edit version-control repository history"
  homepage "http://www.catb.org/esr/reposurgeon/"
  url "https://gitlab.com/esr/reposurgeon.git",
      tag:      "4.22",
      revision: "9a7a672388a05a52f1827eaf61981f81ca9db190"
  license "BSD-2-Clause"
  head "https://gitlab.com/esr/reposurgeon.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5217ed6bdd4c3d325136b99e8ae2dfa29fe4ef51db98c6ef137437a4bf950512" => :big_sur
    sha256 "28136d0965dbdc82293114f1a15f77e98263b4513d440bdb819307e4c8c9742f" => :arm64_big_sur
    sha256 "7ca53ec30c1131eadd40988a29c021c00205d88bf93dcf5d21f836414909cfc0" => :catalina
    sha256 "ebab05fa08478c10feff4cf4e8a8b69e1e02293444eeb6d07cc37980933877ce" => :mojave
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
