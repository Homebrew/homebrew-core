class Ubi < Formula
  desc "Universal Binary Installer"
  homepage "https://github.com/houseabsolute/ubi"
  url "https://github.com/houseabsolute/ubi/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "bb4c14fd505c55443038fc3ef224b56e84a7730eb754ded6322d8b5521b97bda"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/houseabsolute/ubi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ebf9d3609ad1512b19af739b29415c8ea256bc5498877f0f18adbb622a868c34"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "20918fa9c377859db9b6624da7e9089c630b39338499dba2570b0762dd8579bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "98e0476022766b0c6e76000f812afb85f2c9d03f4ec0a0ca7d3ed435813ee99e"
    sha256 cellar: :any,                 arm64_linux:       "519a4eab5cf7cec00fd37a5e44f888dfd47df3915bce74a270483880219938bb"
    sha256 cellar: :any,                 x86_64_linux:      "40923dfd8d29b87459036126e6afd72e252390dada044edfdac5a421bbf4d751"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "xz" # required for lzma support

  uses_from_macos "bzip2"

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "ubi-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ubi --version")

    system bin/"ubi", "--project", "houseabsolute/precious"
    system testpath/"bin/precious", "--version"
  end
end
