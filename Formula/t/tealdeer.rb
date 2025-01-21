class Tealdeer < Formula
  desc "Very fast implementation of tldr in Rust"
  homepage "https://github.com/dbrgn/tealdeer"
  url "https://github.com/dbrgn/tealdeer/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "2b10e141774d2a50d25a1d3ca3d911dedc0e1313366ce0a364068c7a686300d8"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/dbrgn/tealdeer.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "98e3ea943307c047c4bcbd4e71c0c6e753adce66af57e4881fab360b6ad91ca0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e8645f8f68c525cd9b66cf9b703b28f795cd5aee6c875378dca042b0461f70a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fa8716deaae90b75e9597e54474aa7a2c4e55fde790a7b33d4f99f1e5927f516"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d21e8203993929078c44ae1862a9ea569177acf75b773310ae4d5309d35adce"
    sha256 cellar: :any_skip_relocation, ventura:       "ab81dc0b6f9bf01f565d731a64b6500b816a5f616edcfd6416b5e56d3060beba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8fcf5d4d0516caa738d291d7319a78b7dbba8875256ed34e0b3a57d1f905d235"
  end

  depends_on "rust" => :build

  conflicts_with "tlrc", because: "both install `tldr` binaries"
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
