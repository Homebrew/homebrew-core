class Stgit < Formula
  include Language::Python::Shebang

  desc "Manage Git commits as a stack of patches"
  homepage "https://stacked-git.github.io"
  url "https://github.com/stacked-git/stgit/releases/download/v2.2.2/stgit-2.2.2.tar.gz"
  sha256 "6014f7d735eb05fe52f0b163a890fc11857e210e43db749f5c46c49ff2271553"
  license "GPL-2.0-only"
  head "https://github.com/stacked-git/stgit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "433a60293db7ecd32321f8b070b36418002c87de43ff9ca506427fd5c4c653c6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "625546d22456db69817caa8400b2d4694a3080413fefce050d83ed41844ff806"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "896cdc51094545aedbfac0eb1cac8ee0e95ef11228453db69f2eebb808c6a75a"
    sha256 cellar: :any_skip_relocation, ventura:        "1cbde07282eba8c2372b33a577518cba29bca1c22aec3b34d31bb11c0bb5cd2f"
    sha256 cellar: :any_skip_relocation, monterey:       "4883890c097b69e0a07a526c8c0847b7f9ce454f0589bd5b4a8a5366b91a17dd"
    sha256 cellar: :any_skip_relocation, big_sur:        "c77faecacc8c623f31122dd268805adf54e245410426acc54fb833ae64b2858d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4eb57809b554bf4cfac0f344a70ebedf75fcfe62a35859753fe7370ce590d994"
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
