class Reposurgeon < Formula
  desc "Edit version-control repository history"
  homepage "http://www.catb.org/esr/reposurgeon/"
  url "https://gitlab.com/esr/reposurgeon.git",
      :tag      => "3.47",
      :revision => "a98846488b2df75f39de3180085ef9e49603815c"
  head "https://gitlab.com/esr/reposurgeon.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "78c5b14781272ab3bb7faf43cb1229e99ce09589dba6d0e0c2baff4a8fa8b60a" => :mojave
    sha256 "3acbcc4e23c832fcbe70030a682956fbd36d42898b8f0afc02cf2bdc9334b14e" => :high_sierra
    sha256 "c4c3cbaa9428773df404fb1676a23d152b24f012b6508c4aac4f9475ff787aa9" => :sierra
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
