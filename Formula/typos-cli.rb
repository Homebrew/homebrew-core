class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://github.com/crate-ci/typos/archive/refs/tags/v1.15.0.tar.gz"
  sha256 "ce390f96d94ac5cbc4ff881a4bf612415af8a7b03d25cdf72c7b639dbffbd660"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "51b2fbda936306a4923637979999b60eac4d534993c3ca617c867596183263a2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "34b9a637fe92666d167be8032e565e779b9b3d6a3069164dd9206d8e0f72ed2e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "67fd5283fbf46ddfa3973cec0d36ea47de8f2d786b8580f8ade9ce1605987210"
    sha256 cellar: :any_skip_relocation, ventura:        "57a1f7947ffc25d72543350c5852deb4b4e4d1f12505e2f87ec98b97d8f95fb9"
    sha256 cellar: :any_skip_relocation, monterey:       "20fb8b4744635f60524636d6d8fb91a7ef7671582c55b9c9dccb5d84e600ebe6"
    sha256 cellar: :any_skip_relocation, big_sur:        "8f90f2e2d9ba2eaebfad2604f38616ee31f00be015d94c0a758f3ffa480a9da5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ffcf0434b6abde7a0e710b8e2ddde140a6793ba69cf74b2886f2aad5e16eda49"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/typos-cli")
  end

  test do
    assert_match "error: `teh` should be `the`", pipe_output("#{bin}/typos -", "teh", 2)
    assert_empty pipe_output("#{bin}/typos -", "the")
  end
end
