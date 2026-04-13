class Stgit < Formula
  desc "Manage Git commits as a stack of patches"
  homepage "https://stacked-git.github.io"
  url "https://github.com/stacked-git/stgit/releases/download/v2.5.5/stgit-2.5.5.tar.gz"
  sha256 "9d84329c84bbb3e84b97b57aa29a79aa69f13c896f05842cd3a0f46fff3afe57"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/stacked-git/stgit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e9a2472fb50048b0b022f20a5a1043c986cccbb42e26ec119c6d854b6071ee0f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "920ab2c4eb232fca926817eea3d50284eee59a6ca78009321ecae95c2b0a9225"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0a3793db5006b763851e80d888b830e13c3fd17cfaf0eef744a261894a0123b"
    sha256 cellar: :any_skip_relocation, sonoma:        "08987529eab4d62f17063aa78837bdc9ad80486820289a3a24670b497394c92d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a2149594fbddbd6b1a5edd5885301e5a231c2296a09039ce5bf36921be8db37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d416973811f15765d0354ec0c3e22eb468c987bb0dddcd38e10de0a0cd789e61"
  end

  depends_on "asciidoc" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "xmlto" => :build
  depends_on "git"

  uses_from_macos "curl"

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
