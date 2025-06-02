class Stgit < Formula
  desc "Manage Git commits as a stack of patches"
  homepage "https://stacked-git.github.io"
  url "https://github.com/stacked-git/stgit/releases/download/v2.5.3/stgit-2.5.3.tar.gz"
  sha256 "637d9a5d435115a69f2dc5a0273b0c6564fdda7b9483268968fae531343c087f"
  license "GPL-2.0-only"
  head "https://github.com/stacked-git/stgit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4e745cfee06e0fc05f4fe6e3d74e932d309adffc9113d1fb66d7fe308982529"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1fbea2bf33eccc3922aa17a1e8902eaa34a04760d3a9637ad24fe581ac2024c1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "de35d6a19a69bc1786c0d6490661805c5cd98701c6b96aa0b583f32143239d60"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad41f116204667b9bc1192da442908f1d7ce9196d144394a12a9f865fceb9138"
    sha256 cellar: :any_skip_relocation, ventura:       "f28ac3b86b43402de27875ee7f30d9e1af3f0837572e61719aa57a4da15849ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0fa691fa71e1ea4758fafc0d3ea0c85eafbf09487d7a63da08d3b495aca56e55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4be75f0fc9a7c398897966b5b6d1b128a61251b9c555091e770b67ba3fa9e5e7"
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
