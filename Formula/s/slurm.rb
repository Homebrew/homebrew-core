class Slurm < Formula
  desc "Yet another network load monitor"
  homepage "https://github.com/mattthias/slurm/wiki/"
  url "https://github.com/mattthias/slurm/archive/refs/tags/upstream/0.4.4.tar.gz"
  sha256 "2f846c9aa16f86cc0d3832c5cd1122b9d322a189f9e6acf8e9646dee12f9ac02"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{^upstream/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "b4f4153c52ba78d3ad62fa6ff84a348993f2b8a032a41c0dcf5565ddd013be08"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "776f1360da9dd1fa05c2095b37974a193b18eaedaf5a94792e2945242a9bd1f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "45e31ecee4bc3065e733dc130884346f4eabae06012ba29d75da76e5584e6481"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a2e8b79fac19c1d029e8d8f2dc61b39d74abf242f509e0507c1761d0dbd8f0af"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ede14c56489fae8439d7913dc2a173b9ffed43a3ac1c344749a5486ddda29ff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "39ec3975b8d5228214dfed9601b1122e34808d6461353e2e7f76c5b0f569e4b4"
    sha256 cellar: :any_skip_relocation, sonoma:         "e9c134c7ba9d8a1081bcea00b637f7441fb70f9fcbac5187d587a016338afa7a"
    sha256 cellar: :any_skip_relocation, ventura:        "29ded8a4e4b487e71ac6c8c21b2ad05fb7a52c6138d6c4f11f3406ca35cb225f"
    sha256 cellar: :any_skip_relocation, monterey:       "4db77bcd6316bb4e9d8b2070cad506e18dc46c0fbfc326252efb09d86bae8ec7"
    sha256 cellar: :any_skip_relocation, big_sur:        "f887511a3fc673569f504330987bae7100213e4c2ed12bee70db0f94c5465ef9"
    sha256 cellar: :any_skip_relocation, catalina:       "deb0b5005b323d47913ee26328ae1bc17321fb3f09a76f90f74c108b5f23c6fb"
    sha256                               arm64_linux:    "01552c3c4c6ab5bbcce1eb3716ff2ba49e2bb66a683f0d17b7d8c75da30980f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c06bff9e858ad8f9c8583f4149a8a297b099c3d77754a7497978897c89427362"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  uses_from_macos "ncurses"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    net_if = OS.mac? ? "en0" : "eth0"
    output = pipe_output("#{bin}/slurm -i #{net_if}", "q")
    assert_match "slurm", output
  end
end
