class Tcptunnel < Formula
  desc "TCP port forwarder"
  homepage "https://vakuumverpackt.de/tcptunnel/"
  url "https://github.com/vakuum/tcptunnel/archive/refs/tags/v0.8.tar.gz"
  sha256 "1926e2636d26570035a5a0292c8d7766c4a9af939881121660df0d0d4513ade4"
  license "GPL-2.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "7a7efb2e5ce2524bfa04b2942b08e245786ac43a8bf4fe6bfd74ec31b9deef4c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "8cda7483257c117ca1f5fa465c9659b2dd6ca6e88705c95c19a299b0bbdd2319"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "566b47c82002d0bebdd2d445c83e6c32640e42cbbbb9d7b818b0519b62c0f252"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9503c7ec45671862d4d806931e056c9d0c6e7ea9cdda143bd17ea355b6c6a78a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08ea4f67e68abd0d281d62a9f59f172b3ada2f84de3efba2c66318909686fd04"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f551ae0b42199f7636702669a5f32d4fb6bafef330036e8b14f3cfda556a4d32"
    sha256 cellar: :any_skip_relocation, sonoma:         "ab42208d9916d141100118933e3f68d98622d9008af6fb3547e44433769bf9ff"
    sha256 cellar: :any_skip_relocation, ventura:        "8eb0261ee4669e199766ea61e9b9f7ab7cd1b9ca51794f5d26650c542dc55e10"
    sha256 cellar: :any_skip_relocation, monterey:       "d75d983ef25fb64ae2d4fef51dd7c5a29451a3326ae99f2aaf24254d174d9f3b"
    sha256 cellar: :any_skip_relocation, big_sur:        "65ab13dc5646735a64d821e3eab7f04a55bd0739b83b36769b3d0664de74ed80"
    sha256 cellar: :any_skip_relocation, catalina:       "e82c25ab68b43d632739d345b3ac1c3a6d22a9c8a51d44f9cfc3967e64469794"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "59d0cdd268a8b0d3fe0ca85c547c68b185b5a7b6f1159b3a8eb5ac9f50178785"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b82ce2df1293960dc7d0e4b5b9d809198073121331d7287edacbd5cffe17d94c"
  end

  def install
    bin.mkpath
    # installs directly into the prefix so should use bin
    system "./configure", "--prefix=#{bin}"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"tcptunnel", "--version"
  end
end
