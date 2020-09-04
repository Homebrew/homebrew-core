class Tealdeer < Formula
  desc "Very fast implementation of tldr in Rust"
  homepage "https://github.com/dbrgn/tealdeer"
  url "https://github.com/dbrgn/tealdeer/archive/v1.4.1.tar.gz"
  sha256 "eaf42fe17be751985cbf46c170ef623fcbd36028c88c2e70823492a9335a4a8e"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "5a4970ee9547792f323a4a8d7b8049d71a643d458b0f3b6d15ef70402f4efd79" => :catalina
    sha256 "358f7dee83a7c125f56df3e50cb02daa1fb515e8ddd04e65d03fbe1ed0040401" => :mojave
    sha256 "c095afdb06d12e0efa194d16e8169a6c49f219893f8df7df15b1a6f6a62207c1" => :high_sierra
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1"
  end

  conflicts_with "tldr", because: "both install `tldr` binaries"

  def install
    system "cargo", "install", *std_cargo_args
    bash_completion.install "bash_tealdeer" => "tldr"
    zsh_completion.install "zsh_tealdeer" => "_tldr"
    fish_completion.install "fish_tealdeer" => "tldr.fish"
  end

  test do
    assert_match "brew", shell_output("#{bin}/tldr -u && #{bin}/tldr brew")
  end
end
