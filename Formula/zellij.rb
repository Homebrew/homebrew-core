class Zellij < Formula
  desc "Pluggable terminal workspace, with terminal multiplexer as the base feature"
  homepage "https://zellij.dev"
  url "https://github.com/zellij-org/zellij/archive/v0.35.1.tar.gz"
  sha256 "fa92982ea3b1481a1c50065f9d1c3eff2e47ac0deee071ca4752a18424aeb93e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef5dd57fcbdae693e10d4f79dd7bce56154b368133c88ffbfc236eac8ce3cd0f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac7c95957376939cf7c761c4443d1ee310d3caec319f0340e4e881baeac5a9f3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "28a781ee8b7a8a953a7a5eb91f9ee8464f17768d7f6869869955101b8aef1618"
    sha256 cellar: :any_skip_relocation, ventura:        "c22280765c0bbcd152b4bc58d9b3eb1ded85d2c253a55a851b6416dc11501c5d"
    sha256 cellar: :any_skip_relocation, monterey:       "8a7ae1f884576642cdc76d1e56abfb706e7102cef117a982105c1dcec8c7946f"
    sha256 cellar: :any_skip_relocation, big_sur:        "0c8adf3cf8047c5fd819c151aa119409bdc7e6b10ab14d29dcf2a20ae77ddd21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e110a3857b5e8de087b94b1a04dcbbe4d1f75150cf7c10a5f0df3d56ecd09f63"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"zellij", "setup", "--generate-completion")
  end

  test do
    assert_match("keybinds", shell_output("#{bin}/zellij setup --dump-config"))
    assert_match("zellij #{version}", shell_output("#{bin}/zellij --version"))
  end
end
