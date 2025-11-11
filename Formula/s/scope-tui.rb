class ScopeTui < Formula
  desc "Terminal spectrogram viewer (WAV/mic) with palettes and exports"
  homepage "https://github.com/arian-shamaei/sgram-tui"
  url "https://github.com/arian-shamaei/sgram-tui/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "3021eb08bfb114624a4d23164008cb52a7d5fec52e530949c0a089a579440b76"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    bin.install_symlink bin/"sgram-tui" => "scope-tui"
  end

  test do
    assert_match "Terminal spectrogram viewer", shell_output("#{bin}/scope-tui --help")
  end
end
