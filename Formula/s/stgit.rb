class Stgit < Formula
  desc "Manage Git commits as a stack of patches"
  homepage "https://stacked-git.github.io"
  url "https://github.com/stacked-git/stgit/releases/download/v2.4.10/stgit-2.4.10.tar.gz"
  sha256 "eaa01a1bbbba92fd0cec24d66ab85656924337af619b00379c6512804b9887ce"
  license "GPL-2.0-only"
  head "https://github.com/stacked-git/stgit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3267e6f038662fdb86aaaa65b1e1851c3f0c6b076df5bd0470a1ad53cfa0032f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6a20577d373211134cf441f701ef36cbca8efda176c274f1b887cb62dcb0fc19"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8634cb6ebe0ebce0da5652e86d1d02cdf6ed8ec96c499f1f605e71bf8854b835"
    sha256 cellar: :any_skip_relocation, sonoma:         "7c485c116e91c385e10175c099c5d344074bfd5c3187d22ff7d7375359343b25"
    sha256 cellar: :any_skip_relocation, ventura:        "a0ba00049b78c980751ad76801b96c2cb790d78d9f538de2c957a4d52b5af68f"
    sha256 cellar: :any_skip_relocation, monterey:       "424530af3614c50ab217f222433928327c0a210934ebc383c8a040fe0dd009f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a2849dc46de2d6ad9b77115ecf85ce2c195c839d401d4034b3a827c733a4646"
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
    system bin/"stg", "--version"
    system bin/"stg", "init"
    system bin/"stg", "new", "-m", "patch0"
    (testpath/"test").append_lines "a change"
    system bin/"stg", "refresh"
    system bin/"stg", "log"
    system "man", man/"man1/stg.1"
  end
end
