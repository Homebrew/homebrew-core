class Ubi < Formula
  desc "Universal Binary Installer"
  homepage "https://github.com/houseabsolute/ubi"
  url "https://github.com/houseabsolute/ubi/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "fafd4bda8207580ae44ad54c78be990f6a0e0fec6a8387b4d916953c6278f30d"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/houseabsolute/ubi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7c60353904b43b071ac952b92758d3fa607afd6128a2022e38a77d6bd5ed591"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b134f519224f44e1541ac4028480357c03de1b6df034aab6b3256831aa794d1d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0adb188448df5da624c2f9ceec8b1b84122576f94b6462886bc56cb3e3e85991"
    sha256 cellar: :any_skip_relocation, sonoma:        "528672b6c2574b668944495a60da5c448a968922646f3cb758504e874a0addf8"
    sha256 cellar: :any_skip_relocation, ventura:       "6ba488cb4ec85807d44c3be381efe52306ea17389721c2671105a4912b11d2f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d7326d2464f576ce716154d66c4a721703d5966bd05c55af8d28f2c10dc6c091"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a9e5d98fc060b5d6fb875c883a1cecb74be884110fd46a86b569df67cebb4a1"
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
