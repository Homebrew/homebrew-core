class Sentrux < Formula
  desc "Real-time code architecture visualization and health scoring"
  homepage "https://github.com/sentrux/sentrux"
  url "https://github.com/sentrux/sentrux/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "ff8c4a2d6774296c66cb2384eeaed8ea9bfd0267a6eaf4b5d0d3a84dc30286cf"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "sentrux-bin")
  end

  test do
    assert_match "sentrux", shell_output("#{bin}/sentrux --version")
  end
end
