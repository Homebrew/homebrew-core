class Stgit < Formula
  desc "Manage Git commits as a stack of patches"
  homepage "https://stacked-git.github.io"
  url "https://github.com/stacked-git/stgit/releases/download/v2.4.2/stgit-2.4.2.tar.gz"
  sha256 "a9e65ac5cfb941fc823ae3a068f2c8d1df50a5f9a65d7e2462546d7c11e2ac42"
  license "GPL-2.0-only"
  head "https://github.com/stacked-git/stgit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4ead0223c04879b7ae8142048e34d600fcf8f4a6971041f8bcff5574009fcd01"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6bd4afeceead1c64259a4f9b826325a54be22efdbef04f7940673007fb9b7c23"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e63c506f000cd4a9fbbff028f3d20d20acf0da74cc3749a85873622df45ce18"
    sha256 cellar: :any_skip_relocation, sonoma:         "3e36ebe24755760e579847ecfbb8df703d0974df8005b8ea630b6d83a62f6998"
    sha256 cellar: :any_skip_relocation, ventura:        "2967b04d4c63eff6a1f9c17aedd35a821b218471f19bda45d81f2258c0e555ae"
    sha256 cellar: :any_skip_relocation, monterey:       "74952645a0d14aa475d9c17cf2ce4839945bba6a776a00dd179a3ea7595cf1d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe1538b72eb6b9d5e7b7c6934a481e4d647b2fc599db69370dd9ee3f0dd8b9ca"
  end

  depends_on "asciidoc" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "xmlto" => :build
  depends_on "git"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"
    system "make", "prefix=#{prefix}", "install-bin", "install-man"
    system "make", "prefix=#{prefix}", "-C", "contrib/vim", "install"
    generate_completions_from_executable(bin/"stg", "completion")
  end

  test do
    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "brew@test.bot"
    (testpath/"test").write "test"
    system "git", "add", "test"
    system "git", "commit", "--message", "Initial commit", "test"
    system "#{bin}/stg", "--version"
    system "#{bin}/stg", "init"
    system "#{bin}/stg", "new", "-m", "patch0"
    (testpath/"test").append_lines "a change"
    system "#{bin}/stg", "refresh"
    system "#{bin}/stg", "log"
    system "man", "#{man}/man1/stg.1"
  end
end
