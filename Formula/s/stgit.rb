class Stgit < Formula
  desc "Manage Git commits as a stack of patches"
  homepage "https://stacked-git.github.io"
  url "https://github.com/stacked-git/stgit/releases/download/v2.4.5/stgit-2.4.5.tar.gz"
  sha256 "3c77d0a597db6ca01f18c70b85a407620902c012614261a9a20466cfbb18db5f"
  license "GPL-2.0-only"
  head "https://github.com/stacked-git/stgit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fb55ca6ccc8a73b8a9bbdf4c2eef250eebf04a5af59e26100f6c6542b5d4e490"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3f359804ced656041a2957088f892aa9ce888a32aaa0361091d93b2d14f9191c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b478e63f266d598dd2380ac999562eea3ba422d0f510e0d06245366f33282aff"
    sha256 cellar: :any_skip_relocation, sonoma:         "2f262d89bd714ce12dbf155d78e90450c8c0b5b76d578c3677a66d1cb6f2eac6"
    sha256 cellar: :any_skip_relocation, ventura:        "11f0bfb9b442b21e726d2fa6eb44a2b88c62564b13c3c589209bf7bb7b27c3db"
    sha256 cellar: :any_skip_relocation, monterey:       "6c197f7e25963632af8971bb04d962bbe356f26ef50b847f330f8f274792b4d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f074fb55ac2e79c92b6556d25d7e9b68665d64e06cc75e01608b8eb40ef8ada6"
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
