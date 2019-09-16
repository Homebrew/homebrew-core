class Reposurgeon < Formula
  desc "Edit version-control repository history"
  homepage "http://www.catb.org/esr/reposurgeon/"
  url "https://gitlab.com/esr/reposurgeon.git",
      :tag      => "3.47",
      :revision => "a98846488b2df75f39de3180085ef9e49603815c"
  head "https://gitlab.com/esr/reposurgeon.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e92f84c8e427baaa5df7c0661de9aa557d7487dad3f02b673984d1541bc864b9" => :mojave
    sha256 "b528a838e55ea3604c1105d9519b252fb89d39349a3873f64a944abfa0c141f2" => :high_sierra
    sha256 "293f48fc7bb768d48b0b2633188de2a88a770724d016e851fc2dcbeb7f4fabc5" => :sierra
  end

  depends_on "asciidoc" => :build
  depends_on "go" => :build
  depends_on "xmlto" => :build
  depends_on "pypy"

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
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
