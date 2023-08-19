class Slurm < Formula
  desc "Yet another network load monitor"
  homepage "https://github.com/mattthias/slurm/wiki/"
  url "https://github.com/mattthias/slurm/archive/upstream/0.4.4.tar.gz"
  sha256 "2f846c9aa16f86cc0d3832c5cd1122b9d322a189f9e6acf8e9646dee12f9ac02"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a2e8b79fac19c1d029e8d8f2dc61b39d74abf242f509e0507c1761d0dbd8f0af"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ede14c56489fae8439d7913dc2a173b9ffed43a3ac1c344749a5486ddda29ff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "39ec3975b8d5228214dfed9601b1122e34808d6461353e2e7f76c5b0f569e4b4"
    sha256 cellar: :any_skip_relocation, ventura:        "29ded8a4e4b487e71ac6c8c21b2ad05fb7a52c6138d6c4f11f3406ca35cb225f"
    sha256 cellar: :any_skip_relocation, monterey:       "4db77bcd6316bb4e9d8b2070cad506e18dc46c0fbfc326252efb09d86bae8ec7"
    sha256 cellar: :any_skip_relocation, big_sur:        "f887511a3fc673569f504330987bae7100213e4c2ed12bee70db0f94c5465ef9"
    sha256 cellar: :any_skip_relocation, catalina:       "deb0b5005b323d47913ee26328ae1bc17321fb3f09a76f90f74c108b5f23c6fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c06bff9e858ad8f9c8583f4149a8a297b099c3d77754a7497978897c89427362"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  uses_from_macos "ncurses"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    net_if = OS.mac? ? "en0" : "eth0"
    output = pipe_output("#{bin}/slurm -i #{net_if}", "q")
    assert_match "slurm", output
  end
end
