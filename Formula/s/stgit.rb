class Stgit < Formula
  desc "Manage Git commits as a stack of patches"
  homepage "https://stacked-git.github.io"
  url "https://github.com/stacked-git/stgit/releases/download/v2.7.0/stgit-2.7.0.tar.gz"
  sha256 "180a60734935e66bab10d524a367e602bfb3b73c8ab720c4bcdd4b2dcb64004d"
  license "GPL-2.0-only"
  head "https://github.com/stacked-git/stgit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cdb5375d03fcf49f6d04a19489ba6319027312ae15bfc035f84a322194d6867e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a02c56b8183ae8889509dc1751a0b92d963b427282e9e777bd8390347b7e732d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "41cf334a64a9f2af8996f27fb06b7cb74de83d72354e45b3318b026bf3d7c190"
    sha256 cellar: :any,                 arm64_linux:       "65d079218c62a998502f79b406ca1a34a2b5caaf7226bb5f0fd4e3c60fce6958"
    sha256 cellar: :any,                 x86_64_linux:      "42242a4304cc7c2dc27e2f37f5b4b336fc2c4e8cf860f440d913476ab2fad170"
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
