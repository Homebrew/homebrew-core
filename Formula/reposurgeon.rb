class Reposurgeon < Formula
  desc "Edit version-control repository history"
  homepage "http://www.catb.org/esr/reposurgeon/"
  url "https://gitlab.com/esr/reposurgeon.git",
      :tag      => "3.48",
      :revision => "911d5c1168f7839855b577ea43971c7c35cacef8"
  head "https://gitlab.com/esr/reposurgeon.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "aba7163a5984e3fb606b59b70e6c4233cf3d0aa69e400bad156c2a41c4800f3e" => :catalina
    sha256 "7e3c1b86b32535b698098ffc82231ce1cde18512ffce1ea21cc7b70d0a85a535" => :mojave
    sha256 "22f79c6f4746a5fcffe63be2247c748e5335082384a9309bdba061ff686813d0" => :high_sierra
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
