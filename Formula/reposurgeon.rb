class Reposurgeon < Formula
  desc "Edit version-control repository history"
  homepage "http://www.catb.org/esr/reposurgeon/"
  url "https://gitlab.com/esr/reposurgeon.git",
    tag:      "4.17",
    revision: "00147d3ac750882f82ec5751beb6249bcbd6981a"
  license "BSD-2-Clause"
  head "https://gitlab.com/esr/reposurgeon.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f2e2edf15cf9b71ee26df6b878d5178a8b9d748f3d0c07e10c574074baf9267e" => :catalina
    sha256 "dd26bcd8e10850bd9f55db41bc5d5d98757eb1a857d87be3c81737755a480a8c" => :mojave
    sha256 "9d534aae13973bbe43fcf5464da33ff32cc6a211e12ec635ad175884e552009c" => :high_sierra
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
