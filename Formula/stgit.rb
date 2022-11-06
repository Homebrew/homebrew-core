class Stgit < Formula
  include Language::Python::Shebang

  desc "Manage Git commits as a stack of patches"
  homepage "https://stacked-git.github.io"
  url "https://github.com/stacked-git/stgit/releases/download/v2.0.0/stgit-2.0.0.tar.gz"
  sha256 "b7b6d41aeb3fc509444fcf06aca64ad2d8e538900ad75d826c4a64e660ae8a16"
  license "GPL-2.0-only"
  head "https://github.com/stacked-git/stgit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "442b36b832407129281e66f933478a744a621bd2ac53db0dd7b9f5630c042884"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "442b36b832407129281e66f933478a744a621bd2ac53db0dd7b9f5630c042884"
    sha256 cellar: :any_skip_relocation, monterey:       "d3b1b43726c6ae9ba5c846e85bd187592199e539f220be0b4ed22d56a59c07c3"
    sha256 cellar: :any_skip_relocation, big_sur:        "d3b1b43726c6ae9ba5c846e85bd187592199e539f220be0b4ed22d56a59c07c3"
    sha256 cellar: :any_skip_relocation, catalina:       "d3b1b43726c6ae9ba5c846e85bd187592199e539f220be0b4ed22d56a59c07c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "442b36b832407129281e66f933478a744a621bd2ac53db0dd7b9f5630c042884"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"stg", "completion")

    system "make", "-C", "contrib", "prefix=#{prefix}", "all"
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
  end
end
