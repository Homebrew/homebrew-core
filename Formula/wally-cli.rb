class WallyCli < Formula
  desc "Flash your ZSA Keyboard the EZ way"
  homepage "https://github.com/zsa/wally-cli"
  url "https://github.com/zsa/wally-cli/archive/refs/tags/2.0.0-osx.tar.gz"
  sha256 "fd2ae8c12380ecd2ddad6d04351c9e832b8607e795f1f1a17f93c27f697392f6"
  license "MIT"

  depends_on "go" => :build
  depends_on "libusb"

  def install
    ENV["GOPATH"] = buildpath

    bin_path = buildpath/"src/github.com/zsa/wally-cli"
    bin_path.install Dir["*"]

    cd bin_path do
      system "go", "build", "-o", bin/"wally-cli", "."
    end
  end

  test do
    assert_match "wally-cli v2.0.0", shell_output("#{bin}/wally-cli --version")
  end
end
