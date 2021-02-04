class Trunk < Formula
  desc "Build, bundle & ship your Rust WASM application to the web"
  homepage "https://github.com/thedodd/trunk"
  url "https://github.com/thedodd/trunk/archive/v0.8.1.tar.gz"
  sha256 "94cb167f2370a2749bbac7b7b1c5a8ea1f9f49065ddcb2fba4bd7bb977080f76"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/thedodd/trunk.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fd4c0e014e8bc1c92b50b66971051a47c9545b17b1f0e49c39ea9f6bc56034af"
    sha256 cellar: :any_skip_relocation, big_sur:       "6048e4ac198b442011f29daab363a5ad0e63cf0e2c0bdbc55393a74eba7aa8ec"
    sha256 cellar: :any_skip_relocation, catalina:      "eb6f94ad5c40e7a6d93887a3b7379643592f5ccead01874a2be775fb6936b43f"
    sha256 cellar: :any_skip_relocation, mojave:        "0e9519ffc6995c91a89e7a2fe103778cf6be65ca036070d2afef9670db648656"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "ConfigOpts {\n", shell_output("#{bin}/trunk config show")
  end
end
