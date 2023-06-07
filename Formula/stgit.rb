class Stgit < Formula
  desc "Manage Git commits as a stack of patches"
  homepage "https://stacked-git.github.io"
  url "https://github.com/stacked-git/stgit/releases/download/v2.3.0/stgit-2.3.0.tar.gz"
  sha256 "365aee4f6b301568e991901022fe0d908768840e7070efbb04512bd6fd9d5523"
  license "GPL-2.0-only"
  head "https://github.com/stacked-git/stgit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d277f6bb134111bc6e77c32d19e1dda61399c4416735a20159348c05b792febf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "722d809ab81b5f2b29255ef8df3b1319f9f6adaf59334139e4971a849b60b2e9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1559460b7eca04d4af3b69d0f4cb23975777ca294b63c6f93386c5f038fa6cfa"
    sha256 cellar: :any_skip_relocation, ventura:        "5a2a4a18ac7064b8c63b54f4765225f4e9f393d1cf08821f023e711328a7ab9b"
    sha256 cellar: :any_skip_relocation, monterey:       "3caf1a213a5badf2fb544853c6d39708885808588aa24f405120ff014f629134"
    sha256 cellar: :any_skip_relocation, big_sur:        "0142ec92b2ea1d49351f40d6b48a5d18caba69222c627aa66d068fe2a0b849ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cbda2af6b1e779b90537e47667b4fa13110fe113b70a9b715551e0ea7da41be6"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "git"

  uses_from_macos "curl"
  uses_from_macos "zlib"

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
