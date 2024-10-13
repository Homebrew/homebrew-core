class Trippy < Formula
  desc "Network diagnostic tool, inspired by mtr"
  homepage "https://trippy.cli.rs/"
  url "https://github.com/fujiapple852/trippy/archive/refs/tags/0.11.0.tar.gz"
  sha256 "2745d5b02b32bc9de8944ec9c37f27c5dea4c5dedb2b0a9b969e515f2aafdf84"
  license "Apache-2.0"
  head "https://github.com/fujiapple852/trippy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b931aba2b55ec4a741cb5a57998888bcaef264b2491ac28d53bb0bcd5caa7c7b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "370b96d59fd465ec7a8a5c39fef98f6b88be6873a2671518b8819809a060c704"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a60acd7116fed2c316bafbd8647363e7b37fafe80428e729f506c2dc4ca896a8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "38222938365a3a786f621ce9af1672d5fbd53a60887e29c62c661787245e1a7c"
    sha256 cellar: :any_skip_relocation, sonoma:         "cefe35c2de58594c77918734e998e332e27a62efde1c02069e98c548d22b65a1"
    sha256 cellar: :any_skip_relocation, ventura:        "a50a74be065ee5cef0d82854a20536c19a9c536933d884b99675d04777a7adb3"
    sha256 cellar: :any_skip_relocation, monterey:       "dfc782754039b753ebfd7e43d3a154e3182cbd56a791a0235f3a7ccde7fb3ec2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2703305f12b597d0829b02f99c9a2f839b9706d08996df206b60a921c1e3c721"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/trippy")
  end

  test do
    # https://github.com/fujiapple852/trippy#privileges
    expected = "Error: privileges are required"
    output = shell_output("#{bin}/trip brew.sh 2>&1", 1)
    assert_match expected, output

    assert_match "trip #{version}", shell_output("#{bin}/trip --version")
  end
end
