class Stgit < Formula
  desc "Manage Git commits as a stack of patches"
  homepage "https://stacked-git.github.io"
  url "https://github.com/stacked-git/stgit/releases/download/v2.4.7/stgit-2.4.7.tar.gz"
  sha256 "6cb59dbcfc0b485529a44aab4147466bd88be0f11a087e682a6b1b41ce480316"
  license "GPL-2.0-only"
  head "https://github.com/stacked-git/stgit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "79b9afcb8437e5c8af68f4a25c40dbc9445123c26c7d20f0f2bea53ad6a464a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "160fcab91ffe51731fa9554d690332a4c9cbcb239018224d117cc25d6ef1ba83"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0176deb0e083cb6fa7fe95f1fbbd923aa6f18c10bbd26d4b44ff043ee4a641a4"
    sha256 cellar: :any_skip_relocation, sonoma:         "4ab14d13ccedcc839983691045dd1e32c708388c594e8d3d06788c66290e1d79"
    sha256 cellar: :any_skip_relocation, ventura:        "80e1cd1652066f1907412e577e99b8f2e939d4df0f304c559a55883ab97d05b6"
    sha256 cellar: :any_skip_relocation, monterey:       "319499888240bda4b89c9cfc317e8dbfd3763d63ecf18f266c1024653e32bb85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b63c4a7b687251b559a58479e4e0cb07737c3eb15a364a9c3fe01e570e1f67a9"
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
