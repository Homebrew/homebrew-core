class Stgit < Formula
  desc "Manage Git commits as a stack of patches"
  homepage "https://stacked-git.github.io"
  url "https://github.com/stacked-git/stgit/releases/download/v2.4.12/stgit-2.4.12.tar.gz"
  sha256 "78e57becdf234bf3396f4271b32e9c2e44ef03204ad1b2494ee347b22f34f786"
  license "GPL-2.0-only"
  head "https://github.com/stacked-git/stgit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "ed27903a4ea3cd3095848af457761a8036b35c8f15547fe34ea9ede13608ca97"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "98635dcc816c2edb4f918c6636dc5972b0e2479090e469cc754201576fe65af5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b75458852972d1216ffc523044d16ce37838f345fd46ed09a8270f825f8d9e2d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "48ab6b54cbb091457fe22323ea8da1dc81beb270df8afc63da609c8447d7c845"
    sha256 cellar: :any_skip_relocation, sonoma:         "0eded4fff5e0349d544b686bba62cb7138d7cad49856707acd2c45b86417d377"
    sha256 cellar: :any_skip_relocation, ventura:        "8d1de537506841b95835671c19fa5d284c29c0bf53beb32110e146c7c370b917"
    sha256 cellar: :any_skip_relocation, monterey:       "1430445be35828b0c38c68365969e77b070d5486db42b809dcd5fa070570e7ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b0257d2ec41199c32d8f2c3701994732bfabfbec92fbdf9138e169d03306d7a"
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
