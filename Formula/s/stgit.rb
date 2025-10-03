class Stgit < Formula
  desc "Manage Git commits as a stack of patches"
  homepage "https://stacked-git.github.io"
  url "https://github.com/stacked-git/stgit/releases/download/v2.5.4/stgit-2.5.4.tar.gz"
  sha256 "ccd8435177228f6a84a6b706e04c6d50bd5b3f5636b30270a6408e7b5b3254fc"
  license "GPL-2.0-only"
  head "https://github.com/stacked-git/stgit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "68706dbfcc157701b6a546cba0a69f7cd5cd5f6dde1890e0381a9947aa98b9fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c96f21fe97582311cdc5abee743363ead3328f20a77184d94ddd6bcbd334cba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "489238c99e6439cdc34aab55027149540a5971ccafd700c2ffda734453688c93"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6e61c0afc7c47bc38cb4d9ea60046cfac6bf5138d0107f45f66081830113d05c"
    sha256 cellar: :any_skip_relocation, sonoma:        "df156e1a803551b56953427f95d98d689686e98ad1a6243d47ab968c6eaaf80f"
    sha256 cellar: :any_skip_relocation, ventura:       "feed72e3869b2a795a8e40163844a1d4b5f689a46f9f6e8886e77696a94a24aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fca60d8be3921d049e75dba241a9e06f3438db3a036aa1c64c1bc4e30759f53a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e98c643ace9a0f0c55e307c714b9a7686e90a01abfeac3f532ad35015880d1a2"
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
