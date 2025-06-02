class Texmath < Formula
  desc "Haskell library for converting LaTeX math to MathML"
  homepage "https://johnmacfarlane.net/texmath.html"
  url "https://hackage.haskell.org/package/texmath-0.12.10.2/texmath-0.12.10.2.tar.gz"
  sha256 "c671d2084d9f4a3e0796bda783b5e6a7d26ffab5d3dccc44d1caa31a0e59bc0b"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/texmath.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "873038e94de977b82185dec29d7c309853a0b009cdc752f76ec5c0c2b32176c2"
    sha256 cellar: :any,                 arm64_sonoma:  "89dd489c31e1d6f9ad5effb71d33faf14d69ffcdad1f600a015d9e3472faddfe"
    sha256 cellar: :any,                 arm64_ventura: "9b47e206efe0f60c8cb93841ac4915663936f4c45f8da6138c7b538f939d7100"
    sha256 cellar: :any,                 sonoma:        "c0ddab9917660110b1939060cdaccc304945665aa9a444d0ed35e3bc7018ba85"
    sha256 cellar: :any,                 ventura:       "9e9d88b3cf1cb75bab204f4ab27aa710fad55957123924a272409d9b25fbb5e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6eaf082b974fbe00b5be1ef879a0e34a933cfe3974cb33c704024bb202d282f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "327e4cb9fd89cc9c66da77cdba51edca2a2898aad92615df8db7451feeb67fe1"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  uses_from_macos "libffi"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", "--flags=executable", *std_cabal_v2_args
  end

  test do
    assert_match "<mn>2</mn>", pipe_output(bin/"texmath", "a^2 + b^2 = c^2", 0)
  end
end
