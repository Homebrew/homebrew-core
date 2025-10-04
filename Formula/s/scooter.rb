class Scooter < Formula
  desc "Interactive find and replace in the terminal"
  homepage "https://github.com/thomasschafer/scooter"
  url "https://github.com/thomasschafer/scooter/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "11e9ee10e3cdc626d92c497fd3b3567988bfd07f94478a31a031a8e009fc72cb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4af569f924c54c24eee609af4362f5a5c1c6fdf5e4460c8e09475cf1feef5766"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8476ec4dcf8968ea1c198bae325a2069e4e3b11d36bb28af4eb5baf3ab425957"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "509bd674184aadf998162e4379a7238760286413f349d1ecfa9221b43aef7039"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b7b5c01d7fbb4e9444a40e8198862d46847eb0e727ff438f5d4ccc20db057c58"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1ffd855c66cf2a3de087c03e25ff81266e28a859354d1a8eeab29613caa7b8d"
    sha256 cellar: :any_skip_relocation, ventura:       "cbe6f94a85be6c929d921f0714fdeb4838fe0284dee64475bb3b4407050da30d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e0dec2d2e22be7244ce2ae2a5e8a9a65c6aaadcdff1096d61d71f35a132e175"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9a0a1ccf5f5f1c145c36cbde4bcf139d2ed8342df76d3838f259d6221f3e2f8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "scooter")
  end

  test do
    # scooter is a TUI application
    assert_match "Interactive find and replace TUI.", shell_output("#{bin}/scooter -h")
  end
end
