class Stgit < Formula
  desc "Manage Git commits as a stack of patches"
  homepage "https://stacked-git.github.io"
  url "https://github.com/stacked-git/stgit/releases/download/v2.4.4/stgit-2.4.4.tar.gz"
  sha256 "c789091819e9a36dab4cc797e7000e142c49abe8440098121bc9d9123279785b"
  license "GPL-2.0-only"
  head "https://github.com/stacked-git/stgit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1ced0f9d33159cfe32aa48f64de217720726aa62f707decfd02a5787951bd0ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5869839ab7614c7f6eb17e4dfbfb21750c411a36d1ac3cbe3d7d78768fa15621"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eaa50a88e36c994f87ece5ab5a50ee60c415694522ce18383eb46b9488ad5e6a"
    sha256 cellar: :any_skip_relocation, sonoma:         "22899ac0f02002ee781c2866578e0654e0ebc1a732cfe2e5234f3f4860430a64"
    sha256 cellar: :any_skip_relocation, ventura:        "841ce8f6679315859470b552ff7055c6a634e81fa1050d806e91310936231ba5"
    sha256 cellar: :any_skip_relocation, monterey:       "97292d9a064d5aceffeac3fe7002a810a08c679e7888f8b4d4ffd140cf65ddeb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed1fcf0a239bf2440fbc100b3ee01dacb8c1a8e7b5b2c23873c96d2fe3ca5acc"
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
