class Stgit < Formula
  desc "Manage Git commits as a stack of patches"
  homepage "https://stacked-git.github.io"
  url "https://github.com/stacked-git/stgit/releases/download/v2.4.0/stgit-2.4.0.tar.gz"
  sha256 "5836789617a3794f5626194e9670a24497ff5b3f9c779bd13decef3d4e1ee95d"
  license "GPL-2.0-only"
  head "https://github.com/stacked-git/stgit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6b15de104d2043444d48683ed7e4563b7d8251de777f77d4f62a383ec9d27913"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ca85f3fde7b0f5e0e1fe03b3fbb93da980ecc1a6543c4e3b2e9c17cd6c82ff2f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "120ba3b172841812ef229f7f892aba36072d6553f7e7042f31567360524c441e"
    sha256 cellar: :any_skip_relocation, sonoma:         "ffe6da04d401f6dbf2d7c7419ebd82d51005f361d359598994a56270de24b006"
    sha256 cellar: :any_skip_relocation, ventura:        "6ee327bcf491e8a61140f424364270a1ba848c7227418e68db866430117463c6"
    sha256 cellar: :any_skip_relocation, monterey:       "4ffcd985c2338b4c318a4ab12b3a85173d38b2e6a9f0ae712ef206f66dbee851"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ba0a1a8b4fb74a8cc92dd372e82241acf54f113f60986a92297ec3cc03dde69"
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
