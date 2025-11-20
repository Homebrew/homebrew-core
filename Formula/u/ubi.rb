class Ubi < Formula
  desc "Universal Binary Installer"
  homepage "https://github.com/houseabsolute/ubi"
  url "https://github.com/houseabsolute/ubi/archive/refs/tags/v0.8.4.tar.gz"
  sha256 "8f58d2dd267eb9dab99f59e4a9fdc2341f50bafedb1589f9773bc52ca2346f74"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/houseabsolute/ubi.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6c6f9a699bfde76300fc1532f435bdd4c7939959b2abdda9afbc313287eb571e"
    sha256 cellar: :any,                 arm64_sequoia: "ada637809495b61fb3b3b283b6841924e7692422a37a70a398684179b0f3bb6b"
    sha256 cellar: :any,                 arm64_sonoma:  "1fefb670ddea8dd453a69fd9389633d8f29ae224d1877a0dd8a98453ab4badf7"
    sha256 cellar: :any,                 sonoma:        "ef9528fb21add881d327a9fb527b5a72a08762850bdaeff30a9441847cf70dc8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "40e2f9b06fb19d322f130bb10bc68e6a15a97c28f345179b77cad2f7b59d2e40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d3c99cd2d5f4ed6c15ddaa75d592aa6ad821f7ec28ad5c87f9c9ed053214134"
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
