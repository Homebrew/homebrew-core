class Viu < Formula
  desc "Simple terminal image viewer written in Rust"
  homepage "https://github.com/atanunq/viu"
  url "https://github.com/atanunq/viu/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "9682be1561f7a128436bd2e45d1f8f7146ca1dd7f528a69bd3c171e4e855474b"
  license "MIT"
  head "https://github.com/atanunq/viu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "bb007aa864e69c7936012bee5a5fb5db2e0a2137a5203f71f01a049aeea31d39"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "45cfcb1acbd7e19baa29fcbc4a0bd4027f3bfb7110bef2c31b4efd3e332c36bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b7f6b33f89da3410d9cf4f52c8e619b7d47e3389f559ce74711581c5bf6a1e68"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f048a4285ab17c0c33301504ad730131e9a79bd206488851dd667800ec2816b"
    sha256 cellar: :any_skip_relocation, sonoma:         "f7450084c0cfc1232993ba43aee5662691c148dd7af2c95859d5e5e05e5b0827"
    sha256 cellar: :any_skip_relocation, ventura:        "709237cca3b5b6095b1f25458c7cb7e4a512dcd0f05d9b4eb8126ccdda5581b9"
    sha256 cellar: :any_skip_relocation, monterey:       "0c7901a2d48ca4300a67502bf3c1237f65cb9c816332ed603aab9066941f08ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "add357623e3978dad925fa66bc8ef8040644da3e9d2f1809bd2e3228f7eb1ced"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    expected_output = "\e[0m\e[38;5;202m▀\e[0m"
    output = shell_output("#{bin}/viu #{test_fixtures("test.jpg")}").chomp
    assert_equal expected_output, output
  end
end
