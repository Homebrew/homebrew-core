class Tealdeer < Formula
  desc "Very fast implementation of tldr in Rust"
  homepage "https://github.com/dbrgn/tealdeer"
  url "https://github.com/dbrgn/tealdeer/archive/v1.6.1.tar.gz"
  sha256 "d42db25a56a72faec173c86192656c5381281dc197171f385fccffd518930430"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "03ed6d8a46dfaaad1f0f4198fa9479d6925f6bfd58f6d3c95b2d21f832360c00"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fedd60d1a623724b3c66b436c8d1336f8978d6b1e0bf5b87c1891b63f72368cd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "04aaa793695beba680085500b1c45ef336561f50743e6360b560eda2338fcbcd"
    sha256 cellar: :any_skip_relocation, ventura:        "d0ab45756b657907f05358c558e235e850394ec9d3bbdcb17fa288d1c0a22e5f"
    sha256 cellar: :any_skip_relocation, monterey:       "833df803c5b64bfcbf2689da129632ade502d00fb83582ee322059cef358b3f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "fb53881e8ff4d1a74d70bcd2a80c05fe2b34b350eb82c2bcca3ea4002826bf4a"
    sha256 cellar: :any_skip_relocation, catalina:       "1968452b9b39f7b2581864a4547e45c07785aa307e48ee5416cfb7387fd5e3da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "faacf0de290cdd866297f164e841e4ea31e5c3b930ec08caa13591f336b0d7e0"
  end

  depends_on "rust" => :build

  conflicts_with "tldr", because: "both install `tldr` binaries"

  def install
    system "cargo", "install", *std_cargo_args
    bash_completion.install "completion/bash_tealdeer" => "tldr"
    zsh_completion.install "completion/zsh_tealdeer" => "_tldr"
    fish_completion.install "completion/fish_tealdeer" => "tldr.fish"
  end

  test do
    assert_match "brew", shell_output("#{bin}/tldr -u && #{bin}/tldr brew")
  end
end
