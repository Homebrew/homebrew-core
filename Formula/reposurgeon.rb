class Reposurgeon < Formula
  desc "Edit version-control repository history"
  homepage "http://www.catb.org/esr/reposurgeon/"
  url "https://gitlab.com/esr/reposurgeon/-/archive/4.35/reposurgeon-4.35.tar.gz"
  sha256 "7a93f58bd6025c9c2dffac90c58ea7e3bbda8b17c51a181b0a969abe2a6a5081"
  license "BSD-2-Clause"
  head "https://gitlab.com/esr/reposurgeon.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0de5a50cf3c88bb5056e6d9c626a97db4d04a8a8b29370e149c4659a33075515"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8be8a1264dcebcd19b4e6b1fc4fb770ab64d5d0d69249f627d613adaa5efb4c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c7211b6f57467937a856a997e992478f47ff0de976b393bb781722bdb137f8f4"
    sha256 cellar: :any_skip_relocation, ventura:        "0f4187f072c0ae4187343bd49d4242e47d9f62d98075af82a098818fac011046"
    sha256 cellar: :any_skip_relocation, monterey:       "817e3637872e2e8e91652b6826199be80697f2767b6e0f39e47fd58f54355a47"
    sha256 cellar: :any_skip_relocation, big_sur:        "e0bacd8e7cd6f65961726c76ca5ce6b8a16900c464f50e2626246efdea317c48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05506075610cfa288db7c3cec4cbc62091985cd30b7986e942f3480c265e78fb"
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
