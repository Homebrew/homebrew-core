class Ubi < Formula
  desc "Universal Binary Installer"
  homepage "https://github.com/houseabsolute/ubi"
  url "https://github.com/houseabsolute/ubi/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "4d84b02d8f7f764209085674b95964702cbaa90bde731bc95fae43097f4df0e1"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/houseabsolute/ubi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "faaa84da96b0fb52e8a143c9a79158cc9df60f62a1f0a356445c12e207ab2a2b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "973d477ff4a69494e8941d937dfa86c33b2ec401190d5125754e2401efa559e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a253d8119f13fb80d2ba4f06c970e84917801811a10b5cec9585bce4b8edacb1"
    sha256 cellar: :any_skip_relocation, sonoma:        "43382cf96b8c17c32eb99e6343e9f35b96b433dc72e3c605710799948f4f8f79"
    sha256 cellar: :any,                 arm64_linux:   "64470508000e0341a7b11f79511c1832280953279a1c0496df7095cd01204ca4"
    sha256 cellar: :any,                 x86_64_linux:  "9d2e890fa64b3ba9b3a795c77c58e76de616cf08e71789a54d93d9545573ca13"
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
