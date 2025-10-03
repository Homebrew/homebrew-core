class Ubi < Formula
  desc "Universal Binary Installer"
  homepage "https://github.com/houseabsolute/ubi"
  url "https://github.com/houseabsolute/ubi/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "f32ced737f95b854367592243da53e4ac9d4adc37c40bbe4ec178cfcfe36914d"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/houseabsolute/ubi.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "89ea19bc498883b4b0ed4732f71ecdd956f438940009d7f73494745549f1a074"
    sha256 cellar: :any,                 arm64_sequoia: "b399858ce6c347479ac37d43d5ed4cb0021f99557d6af7083ceea28d8eec5d59"
    sha256 cellar: :any,                 arm64_sonoma:  "d95717b66e48b9e6f086ed205fc2c85af71a13692c937366cbfe0551abc48dec"
    sha256 cellar: :any,                 sonoma:        "fd870aab120f7260c9710f94fae58553ebc130a51b71b74af8c37b55762c6d4b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "404956b70a6ae6476dd355044c162f8de95cadead68bb00932439d5c3b246bd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d4a9a662d3ec657434e721790eccff3a2cfa11fcee566b83d7fd3903d76eaa3"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "xz" # required for lzma support

  uses_from_macos "bzip2"

  def install
    system "cargo", "install", *std_cargo_args(path: "ubi-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ubi --version")

    system bin/"ubi", "--project", "houseabsolute/precious"
    system testpath/"bin/precious", "--version"
  end
end
