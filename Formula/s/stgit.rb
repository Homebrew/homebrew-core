class Stgit < Formula
  desc "Manage Git commits as a stack of patches"
  homepage "https://stacked-git.github.io"
  url "https://github.com/stacked-git/stgit/releases/download/v2.5.5/stgit-2.5.5.tar.gz"
  sha256 "9d84329c84bbb3e84b97b57aa29a79aa69f13c896f05842cd3a0f46fff3afe57"
  license "GPL-2.0-only"
  head "https://github.com/stacked-git/stgit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cfa705de0e5b9cf7922189296afc03f16fef2811f5c24cedbe5c135d5cb95429"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "865742c4070ee13e3c4748ac2bcae3922f672ab08ddaa79ca8464460e35d4cf3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0cff8da4697cfc9c7194d8ea374f17a1a91294034f4100cfb4f2f4b8a8e66c4b"
    sha256 cellar: :any_skip_relocation, sonoma:        "af4ca09482dab011146d4a1a2f70b9ec064ccd206746dcfa2239d64ef49235aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c269dbb61d372efc698fe438f201358a25799455964580b5759d7af287a21394"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f763cbd3a555abae3450c8d3bd755f1cc6def5ecec49d20764653a38f9875fcc"
  end

  depends_on "asciidoc" => :build
  depends_on "pkgconf" => :build
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
    system bin/"stg", "--version"
    system bin/"stg", "init"
    system bin/"stg", "new", "-m", "patch0"
    (testpath/"test").append_lines "a change"
    system bin/"stg", "refresh"
    system bin/"stg", "log"
    system "man", man/"man1/stg.1"
  end
end
