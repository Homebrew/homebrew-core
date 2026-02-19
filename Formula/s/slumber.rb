class Slumber < Formula
  desc "Terminal-based HTTP/REST client"
  homepage "https://slumber.lucaspickering.me/"
  url "https://github.com/LucasPickering/slumber/archive/refs/tags/v5.0.0.tar.gz"
  sha256 "10d578b5d74da0d6e572d3dc51b89a5c4d46cc630baa4854dff76be4a35ed656"
  license "MIT"
  head "https://github.com/LucasPickering/slumber.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "59a67d8c86ba70454511c20e4afa05f0f0e6a7cc56d6ed9181d3fbd789b78f08"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c52d76c3c30e86d77891d36ccd905caa5bb73ad2adc4143e1bae05bf707a656d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7de28fd1a0f232e19e54b7e84929718ea551a4955b0142df9c739b147dfeadc7"
    sha256 cellar: :any_skip_relocation, sonoma:        "7de65670c47f2c72377b298c0ae8d888518635cb607adb8ac9da2eb3d1178089"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "470b56e2fde6c1268a6670a574aacbb90fedd7ba27ed958c1785567364448edb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22c8495dd66868bfd340af76cfc677ea3f41bc56889f9b6387452d2eb69e8a0d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/slumber --version")

    system bin/"slumber", "new"
    assert_match <<~YAML, (testpath/"slumber.yml").read
      profiles:
        example:
          name: Example Profile
          data:
            host: https://my-host
    YAML
  end
end
