class Stgit < Formula
  desc "Manage Git commits as a stack of patches"
  homepage "https://stacked-git.github.io"
  url "https://github.com/stacked-git/stgit/releases/download/v2.5.5/stgit-2.5.5.tar.gz"
  sha256 "9d84329c84bbb3e84b97b57aa29a79aa69f13c896f05842cd3a0f46fff3afe57"
  license "GPL-2.0-only"
  head "https://github.com/stacked-git/stgit.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "2245c222ebdc50df69174e08fca409001fa02cc99834cac0a475c1a3394c3f18"
    sha256 cellar: :any,                 arm64_sequoia: "0ef7c40a70e9e127f869c3dfc533655d59dc8269118af2b3aeea7f9bcd952333"
    sha256 cellar: :any,                 arm64_sonoma:  "b10ad29537f513ca8610cfad69ae4edc674a8cb6c357cb9c1144153803baa125"
    sha256 cellar: :any,                 sonoma:        "ab4711c2838f32cbe2a605b5475b67026db843aec069749f08e280716d68df26"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "292c59af8ad6eece0537482b16abaf7e65b8ba7c56cd251e2aa3bf98fde34619"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "429022ab9a5b49d42b49966aec2a1dfec8049e50abda14c6b790da3028cf4a7b"
  end

  depends_on "asciidoc" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "xmlto" => :build
  depends_on "git"

  uses_from_macos "curl"

  on_macos do
    depends_on "libiconv"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
    system bin/"stg", "--version"
    system bin/"stg", "init"
    system bin/"stg", "new", "-m", "patch0"
    (testpath/"test").append_lines "a change"
    system bin/"stg", "refresh"
    system bin/"stg", "log"
    system "man", man/"man1/stg.1"
  end
end
