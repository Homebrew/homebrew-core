class Stgit < Formula
  desc "Manage Git commits as a stack of patches"
  homepage "https://stacked-git.github.io"
  url "https://github.com/stacked-git/stgit/releases/download/v2.5.1/stgit-2.5.1.tar.gz"
  sha256 "a3cfb32208cbfddb4636528cff4154b17aa64f55d34797d80deb29f0a3755266"
  license "GPL-2.0-only"
  head "https://github.com/stacked-git/stgit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b2c0d1d5422f51ae4f4de51bd767fa65d98bf161df9c2429c3c7b1660829404"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2baea74d5a90938d898c594ebc0f30286bd79e28a0b7a7ee15d5d7a7d16232d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d8863184cfe96d37e9b6ccd02c826e4b85e32b295d785018372e195a5a01e762"
    sha256 cellar: :any_skip_relocation, sonoma:        "2681d05c3a563270bface75eb8758c4eddc81056d11e05a495a34b5b37c831c6"
    sha256 cellar: :any_skip_relocation, ventura:       "2b1693276f0296dc542f90247d0f23436e71878cafa95f89dd62a820775f8a8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a1c975bb45c6113f47b5ecb3b397f51fad5083b3150bb54807befcf64b3b0fa"
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
