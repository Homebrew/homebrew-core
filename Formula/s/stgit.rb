class Stgit < Formula
  desc "Manage Git commits as a stack of patches"
  homepage "https://stacked-git.github.io"
  url "https://github.com/stacked-git/stgit/releases/download/v2.3.2/stgit-2.3.2.tar.gz"
  sha256 "8d337a9e998c8b7e5ad5b0d061aa65c241071b6af5274ab2bc796fc1e8c808d5"
  license "GPL-2.0-only"
  head "https://github.com/stacked-git/stgit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aad33ef5ad466d0309837d7833fc31d6ab8c6b5649567a041fc64e84e968fe3a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "55385c02a13ed971938d151bb387f55a90cbb304122ab85f2df8538ba19b1db6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "58066bbf80c510ebeac1f0ac8c79221ec3518eba346f322f4fa9d6494edaf508"
    sha256 cellar: :any_skip_relocation, ventura:        "9fa293871d35f0f5ce0ea5da69b9455e52397e7f674505dbce3c3e922177e450"
    sha256 cellar: :any_skip_relocation, monterey:       "c02c0d71c6482bc62b70606f0df9778aa06eac91eeb443b4a64ed4a417b6de6e"
    sha256 cellar: :any_skip_relocation, big_sur:        "801f90006ed1ec8381948d1e04cf8edb01b16392d1ec3c84650ae1f47f6b63d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12e5ab3b82281bdeb188c5586f177eca73926df1e68a39ca9c220198b303f0c4"
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
