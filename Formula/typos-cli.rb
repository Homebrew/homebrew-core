class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://github.com/crate-ci/typos/archive/refs/tags/v1.13.8.tar.gz"
  sha256 "1d86bf32691ba63e13f5bdbd6267b886f7364893ff0b9aae6120ba7cde59f899"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1bc2436edacbdf26d45c56ec7a2ad2a9de9839b72724423cb86b6d183c82c655"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef55c3f31bc37e0c5d65eb58c7c6e36395162139aec5f1a707b07b6c434dc8f9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9e9d21db3484e6771ec8c30a7e977b958c199c2fce3d0dffe1bc6a29e11db31f"
    sha256 cellar: :any_skip_relocation, ventura:        "acd5516f542e01615df3399aa2770c79ef5d3d5da08c8e2f2c14a33b8a6b167d"
    sha256 cellar: :any_skip_relocation, monterey:       "debcf8bf35452b14e08c9264f8c1d57312bb17ebe05c552d65e0df141b73cfd0"
    sha256 cellar: :any_skip_relocation, big_sur:        "26329330f5d571b239b53c4f5fcb15cfd21d9b56c54f3b80edcb88480868d1c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35e81fc9811557ab9ee1cd630230a5ff7d1b593932733a67b9077a9685e4a86a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "error: `teh` should be `the`", pipe_output("#{bin}/typos -", "teh", 2)
    assert_empty pipe_output("#{bin}/typos -", "the")
  end
end
