class RRig < Formula
  desc "R Installation Manager"
  homepage "https://github.com/r-lib/rig"
  url "https://github.com/r-lib/rig/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "a6f0331d45e0277629515cf6659b4db359387be80c8788a6110145e4350a7947"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe5defa6b5af48a59774d14dae1556d402c603f89572c07168089c935e898010"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33fa01a2f31adccd71f719eea4615382a595d785813a35ee2c114208d81ae838"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8fa195e9987e430abe4f57498a00f2558c1ea0a4f70aff6744dc2ee2b03b48d"
    sha256 cellar: :any_skip_relocation, sonoma:        "fcec14e3f72dbf0c8f8da5de56219bbaf77dd1d5db7b145579830c57561db6b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a3b7fc23b8e34ca7aa1a6a80c4e908c00f76f247328255f8caccd88194562e1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7cf6f120a7d70fcde340d7b9736a00f678423d91d3b7242f628b0ea9991d3120"
  end

  depends_on "rust" => :build

  conflicts_with "rig", because: "both install `rig` binary"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rig --version")
    output = shell_output("#{bin}/rig default 2>&1", 1)
    assert_match "No default R version is set", output
  end
end
