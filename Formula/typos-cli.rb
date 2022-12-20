class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://github.com/crate-ci/typos/archive/refs/tags/v1.13.5.tar.gz"
  sha256 "48cb286f5bcc7f0d82418711582b8236ab0cecf3ce2b320f2fa443794dfba26f"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4e9dae03b16fe77bda08952bbe0ce905383d142bfac2294bf1fbdb4eb6d526ce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "229f85ad48da2be69e9126092364511b817722f5e137bf417628d2dd162905cf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "913756a1fbadb83ee266cb9f45c9dc66c8a4debed39311dfb4ffe6a954a4aa70"
    sha256 cellar: :any_skip_relocation, ventura:        "5fb5cfc77fb16629e1a2d2d20f9d309d3a2fb7393955e11382d815088868b50d"
    sha256 cellar: :any_skip_relocation, monterey:       "6ca19e7020879d6b4592ae5f91832bd9449238c9f8670809a659f3c429c5fdff"
    sha256 cellar: :any_skip_relocation, big_sur:        "e44468d4eefcd04c53b9947b9388fc7a4f9493c2fdad2e6acd3f6716946d81d8"
    sha256 cellar: :any_skip_relocation, catalina:       "744ff9f4a70a05cdf3b7e53c527187bd30e5ffda628f5a320a89adb99565f7f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "946d7ba3bb2d29d15a42f13996261d9163327392fe057363b8e63f74f90d264d"
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
