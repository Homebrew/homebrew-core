class Teamtype < Formula
  desc "Peer-to-peer, editor-agnostic collaborative editing of local text files"
  homepage "https://teamtype.github.io/teamtype/"
  url "https://github.com/teamtype/teamtype/archive/refs/tags/v0.9.3.tar.gz"
  sha256 "c018dcd454645a01b8a0db5996b4f402471bc5c6ee2ad19091b9e30bbee993c7"
  license "AGPL-3.0-or-later"
  head "https://github.com/teamtype/teamtype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "26a9d361e16c3df573bcb67519841e7d4adf5888f36f1d01a0581d9bc6c07a21"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "14bcd3a933d5617ee1e77bf49cf4bafbeedf8115560d65b18784f85f766d4a19"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d77b5b2a78cd3daed2ec8c08f8dd4f141b63c3ccb35306fd00bffd8d34c98bcd"
    sha256 cellar: :any,                 arm64_linux:       "88385e1e266da4be7a885ffda32cbba88c129d41a76147fedfab2992faaed312"
    sha256 cellar: :any,                 x86_64_linux:      "af6dbe87fc8c28b22ce36928aedd156f3dea338523e5699885bab3b857be2d16"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/teamtype")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/teamtype --version")

    (testpath/".teamtype").mkpath
    expected = "For security reasons, the parent directory of the socket must only be accessible by the current user"
    assert_match expected, pipe_output("#{bin}/teamtype share 2>&1", "y", 1)
  end
end
