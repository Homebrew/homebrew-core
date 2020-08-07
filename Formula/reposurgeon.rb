class Reposurgeon < Formula
  desc "Edit version-control repository history"
  homepage "http://www.catb.org/esr/reposurgeon/"
  url "https://gitlab.com/esr/reposurgeon.git",
    tag:      "4.16",
    revision: "f8717b4f0a8b4f051037f26201b0a340538b41c2"
  head "https://gitlab.com/esr/reposurgeon.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b66f514eadf1c9c1b05a953cf8ffda7623adc2ea6a1e828926e9658e52458956" => :catalina
    sha256 "ee5bdbf4903ce0a7be0916f4b0193db771984ade17b670dfcfa33db2ace7e226" => :mojave
    sha256 "124eca67a4500349387b3a28cc237a65f520bff81d508c83d0cd6513345f0292" => :high_sierra
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
