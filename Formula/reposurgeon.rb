class Reposurgeon < Formula
  desc "Edit version-control repository history"
  homepage "http://www.catb.org/esr/reposurgeon/"
  url "https://gitlab.com/esr/reposurgeon.git",
      :tag => "3.44",
      :revision => "f37fa1aa8e3235bb4c64cbcd9e85a6907b4dea50"
  head "https://gitlab.com/esr/reposurgeon.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9666a908f723015481c74de2aa895ff09f55a8a66cda57317c681593d0cf87f2" => :mojave
    sha256 "8dae663f9138b383b4fdbe1f8a66b87cbb05f518ae929441ff46707b5bade762" => :high_sierra
    sha256 "2dc5be9011fa4d7aad8f5ecc6ff125876a61769341d15661f93513e5603a8733" => :sierra
    sha256 "d0ff9f9c06bd124bc9e8dc31bf59eaae1a28b124234d4b359ad719144cdff9ab" => :el_capitan
  end

  depends_on "asciidoc" => :build
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
