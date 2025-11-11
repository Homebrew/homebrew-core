class SgramTui < Formula
  desc "Terminal spectrogram viewer (WAV/mic) with palettes and exports"
  homepage "https://github.com/arian-shamaei/sgram-tui"
  url "https://github.com/arian-shamaei/sgram-tui/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "6bde58115351f2d328ec827352cef3faef610a8f94d671a52473565a41414f46"
  license "MIT"

  depends_on "rust" => :build
  on_linux do
    depends_on "alsa-lib"
  end

  def install
    system "cargo", "install", *std_cargo_args, "--features=mic"
  end

  test do
    assert_match "Terminal spectrogram viewer", shell_output("#{bin}/sgram-tui --help")
  end
end
