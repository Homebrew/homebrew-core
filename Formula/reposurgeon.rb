class Reposurgeon < Formula
  desc "Edit version-control repository history"
  homepage "http://www.catb.org/esr/reposurgeon/"
  url "https://gitlab.com/esr/reposurgeon/-/archive/4.32/reposurgeon-4.32.tar.gz"
  sha256 "5ebb884dda0abde29114fa7f20bdbc11aff8a50ddd6f017052f944799faccec5"
  license "BSD-2-Clause"
  head "https://gitlab.com/esr/reposurgeon.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b8bf9d020558c7d54100aca51eee721cfbe86c503e651a3d1b9b1a4da933b20"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "975f6b3b2d28cb6cae792a116c71e9b22a296022aa21c11cd0a03c77c1ca1ea2"
    sha256 cellar: :any_skip_relocation, monterey:       "33547672b035880844ee44db3e7d760bf96c65a58b92767917d1a38ab243a0c3"
    sha256 cellar: :any_skip_relocation, big_sur:        "efc8c882015e8238d3a127e5a6121aa526f2a2e9bb38d9a4ae58854db43e1a14"
    sha256 cellar: :any_skip_relocation, catalina:       "08735096b9d1c6d211b75b6358ab398d936ea06158116d21aa6623bf84aef384"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a95070ef0b7852e546d65057e6c44d761e4737c5b8e7feff6917294182964e47"
  end

  depends_on "asciidoctor" => :build
  depends_on "gawk" => :build if MacOS.version <= :catalina
  depends_on "go" => :build
  depends_on "git" # requires >= 2.19.2

  uses_from_macos "ruby"

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
