class Tealdeer < Formula
  desc "Very fast implementation of tldr in Rust"
  homepage "https://github.com/dbrgn/tealdeer"
  url "https://github.com/dbrgn/tealdeer/archive/v1.6.0.tar.gz"
  sha256 "7e957b8f440264524822d855af856a634d48a8150a11089bcf8252e42a9ec5e4"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e8dba260e24870180e524d428ce5313e517bd78c1ef4cffe764ec32221c150c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e21ecaa6dd21a3b826d268b4f8d9f333060c2d3fbcf369a9f88069880825a7e0"
    sha256 cellar: :any_skip_relocation, monterey:       "403b266d509fe646846dd25b3d8561287952b7565963f944cc548a1cadf8f901"
    sha256 cellar: :any_skip_relocation, big_sur:        "c9edf21ada213f6d2182faf3bf1101adc97cc9b5e4973cb6441d06062028c788"
    sha256 cellar: :any_skip_relocation, catalina:       "3935f536c903cf0093a933af57655e772c1717e96de111ee41d589966652f4ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0fc5f32014abd2beed6319ebc8d8e81bda2c8e244dc77aa0e20f9a43aa88b0d0"
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
