class Reposurgeon < Formula
  desc "Edit version-control repository history"
  homepage "http://www.catb.org/esr/reposurgeon/"
  url "https://gitlab.com/esr/reposurgeon/-/archive/4.35/reposurgeon-4.35.tar.gz"
  sha256 "7a93f58bd6025c9c2dffac90c58ea7e3bbda8b17c51a181b0a969abe2a6a5081"
  license "BSD-2-Clause"
  head "https://gitlab.com/esr/reposurgeon.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "85bca788fc241e62be4f4c910706a5d486451928d7a46c62746a87de214e0924"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f7a1927c6aaead8eb4f7ba70a129305b182e0937bd5c695929d1466e6e5894b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c1561ede71954018f545db098afdbe6dc872add74b6750aa9c438f8f2f1be104"
    sha256 cellar: :any_skip_relocation, ventura:        "b46775ac4be824afb2ec1658824afcf73edbf2a5c83494a3c27afb8fbaf171d8"
    sha256 cellar: :any_skip_relocation, monterey:       "ca9ac1c0d89a1920720ca581002109c779aa1cc0d01c2bb2e37c9d4c3da683b4"
    sha256 cellar: :any_skip_relocation, big_sur:        "2540f59aedec2a53b2bbb4feb9bac0eb0d1b7e2482d185198463a4249df664c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9165129cd0d2ab3d45dcf2c7f5b6722ff84eefd6ff6b181c0e96f035e7b32dd"
  end

  depends_on "asciidoctor" => :build
  depends_on "go" => :build
  depends_on "git" # requires >= 2.19.2

  uses_from_macos "ruby"

  on_system :linux, macos: :catalina_or_older do
    depends_on "gawk" => :build
  end

  def install
    ENV.append_path "GEM_PATH", Formula["asciidoctor"].opt_libexec
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
      shell_output("#{bin}/reposurgeon read list")
  end
end
