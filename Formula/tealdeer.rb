class Tealdeer < Formula
  desc "Very fast implementation of tldr in Rust"
  homepage "https://github.com/dbrgn/tealdeer"
  url "https://github.com/dbrgn/tealdeer/archive/v1.3.0.tar.gz"
  sha256 "d384176263c1377b241f4e41f8efd564052e506af00e014240f3874419e187e0"
  license "Apache-2.0"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "9db1cd67e060652967a899a4266758bf0b460b1426bea40a822f217c4edf4d80" => :catalina
    sha256 "379f9775e19bf959868350869913b83458b3f14b4aacdd4e5432c2a4cdcf8e9d" => :mojave
    sha256 "fd5d4b07815554a32fc161accc1145d1a7ef761bd20f2f94bdb94eca57563e32" => :high_sierra
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
