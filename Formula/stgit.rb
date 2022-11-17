class Stgit < Formula
  include Language::Python::Shebang

  desc "Manage Git commits as a stack of patches"
  homepage "https://stacked-git.github.io"
  url "https://github.com/stacked-git/stgit/releases/download/v2.0.2/stgit-2.0.2.tar.gz"
  sha256 "17c9afadb4a652e0ed0a806c5618b1ba74c755f26d29d625ebfbebd9de3ea996"
  license "GPL-2.0-only"
  head "https://github.com/stacked-git/stgit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b4f149a8d8e02d9e7b73348e10d195c21fd33092e732ec09a9645c6f97eb77c2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "304c402c2dfeba2d42c4baa08ed2d658c01318b8fa326ca16eb10610fa4a22f4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "21989603912edf108171044a071bb1d8528d6f67ad2d9f1a76b0386ba5e43a91"
    sha256 cellar: :any_skip_relocation, monterey:       "340fe29335ea4db3788b479bcfa60c7f62c17df06db7eb81b538d36ba34b7cfc"
    sha256 cellar: :any_skip_relocation, big_sur:        "cd34295345d4976af573c5e386f30b1a350476a8dff6db30d12c045811b3ff86"
    sha256 cellar: :any_skip_relocation, catalina:       "d2b13d23a4a835cc4767ef48fad0cf225553abbffe3cb46bf78d364f1a308d9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1060b2405423d9ec30671f5b7b62276d47f3a7f083270b12c1d9f858a2aa8492"
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
