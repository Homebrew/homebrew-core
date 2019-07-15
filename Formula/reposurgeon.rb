class Reposurgeon < Formula
  desc "Edit version-control repository history"
  homepage "http://www.catb.org/esr/reposurgeon/"
  url "https://gitlab.com/esr/reposurgeon.git",
      :tag      => "3.46",
      :revision => "0966b8347055ab604c823f0c483c2952564e0c09"
  head "https://gitlab.com/esr/reposurgeon.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "17135750b91d0d57290d3e827a536cb320c7721716b6fe8916bbcc4ab0f71f9c" => :mojave
    sha256 "db8870f19227f9c49c9bc830a3966d40566b463d73852c3e6841675edb8e6e26" => :high_sierra
    sha256 "17dda2be1c0f20331e01f528900466b70bfcaffa607249cfa417e0d99fd28d37" => :sierra
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
