class Stgit < Formula
  include Language::Python::Shebang

  desc "Manage Git commits as a stack of patches"
  homepage "https://stacked-git.github.io"
  url "https://github.com/stacked-git/stgit/releases/download/v2.0.0/stgit-2.0.0.tar.gz"
  sha256 "b7b6d41aeb3fc509444fcf06aca64ad2d8e538900ad75d826c4a64e660ae8a16"
  license "GPL-2.0-only"
  head "https://github.com/stacked-git/stgit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5a55ae0799a6cb973adca1ca0f8ae3460e838064b0d2680d2820739ed88d033"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a5aeb6cea434dfcbb7cb8d16b431922371ef8cc916f1cb5ac2f5f27d00ba4f97"
    sha256 cellar: :any_skip_relocation, monterey:       "066b80619a1ee84f8383bf36f08b1be9c025f878ab5a42354599f5e9f4f74266"
    sha256 cellar: :any_skip_relocation, big_sur:        "1ae6e6b8772c1a2cd5a89f5f5899dfe1101b53e295181d8457bb35d03ad02702"
    sha256 cellar: :any_skip_relocation, catalina:       "8ff9a2e89b753d9c7a8491b50af719d29225905027cb24cf45272efbba5b5992"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f35d7379f6be92450b2cbb96d1d724d6b5b83dd1bb71636826735c93d5cc5e7"
  end

  depends_on "rust" => :build
  depends_on "git"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

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
