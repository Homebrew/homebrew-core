class Radare2 < Formula
  desc "Reverse engineering framework"
  homepage "https://radare.org"
  url "https://github.com/radareorg/radare2/archive/refs/tags/6.0.7.tar.gz"
  sha256 "315f988cb5cc6f0e243bf191227cec1f54382056bdf7a1a21b26719528982a1f"
  license "LGPL-3.0-only"
  head "https://github.com/radareorg/radare2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "b68721cb6f8c9e113d94a9b70bfb8f7daa70eaf0c55dd5289d5aa6b9a86940ea"
    sha256 arm64_sequoia: "9a4601f4e576663894e882121d9be4ca7ccbf7d625f09ea9accab6d625986ac0"
    sha256 arm64_sonoma:  "04849ef4c1ca69ee3c0d6627f371bc362b8aa844cae50c29f6354993d9b1e55f"
    sha256 sonoma:        "1baa0b23eb4953bfc03e9b7ae97be13ce10525e1ee673e6b5409da976b90f042"
    sha256 arm64_linux:   "daa2a8a270b5924e9c4bda27c6fa5f84a30b10400a5404912578340ab4450e36"
    sha256 x86_64_linux:  "b603b1042b6ae39b1dd640c420c9b42fbc23ed8636a8c2c0119adc94dad8fab4"
  end

  # Required for r2pm (https://github.com/radareorg/radare2-pm/issues/170)
  depends_on "pkgconf"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "radare2 #{version}", shell_output("#{bin}/r2 -v")
  end
end
