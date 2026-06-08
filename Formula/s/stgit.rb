class Stgit < Formula
  desc "Manage Git commits as a stack of patches"
  homepage "https://stacked-git.github.io"
  url "https://github.com/stacked-git/stgit/releases/download/v2.6.0/stgit-2.6.0.tar.gz"
  sha256 "b03f8e123726253013fd1a03d8ebb89d53f1e130cc4612ffbf96ec8d96c8bfc0"
  license "GPL-2.0-only"
  head "https://github.com/stacked-git/stgit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aba595a6726d01e99a46159d6844641d15e31c4d93425fbd5890830973323f89"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d1e2bf927352329a5621232e8330a7049c6acd869ca2a71faba227a70cc6d43"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7addb698a2de3608ddfa3b836fa9764f6505bec60cfcf65d01612ccb38ac0609"
    sha256 cellar: :any_skip_relocation, sonoma:        "9894fcc065b4eea2fc8f5bed51cf13b16874bbff0517aeea7e18101949cf1001"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "29ecbd0e882a5de44ecaa410fa5ba8ad568144a237f113290721322fde3df327"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ee51c93a35b3f0573c436c08b4c88720365b27d0b343d4b5e4027aa0bc2868a"
  end

  depends_on "asciidoc" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "xmlto" => :build

  uses_from_macos "curl"
  uses_from_macos "git" # needs git >= 2.2.0. Consider using system git on Linux once RHEL 7 ELS ends

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
