class Texmath < Formula
  desc "Haskell library for converting LaTeX math to MathML"
  homepage "https://johnmacfarlane.net/texmath.html"
  url "https://hackage.haskell.org/package/texmath-0.13.3.5/texmath-0.13.3.5.tar.gz"
  sha256 "6858245031f5d0247beff4020a71d24f5c732cc1be3062db00e8b185f677a212"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/texmath.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b8c107e6e088f4f5310d570969f0b34065f6fc2329d5df42cd6d4fa11af7ebb4"
    sha256 cellar: :any, arm64_tahoe:       "2b1f0e608369b89f7eef68096bf1d05058d79107e1e16a18913e12cd7f2878d9"
    sha256 cellar: :any, arm64_sequoia:     "cd2ac19b3c0557b544d941f9f295558eb5c2f70f8db80449141957db41e3f7cf"
    sha256 cellar: :any, arm64_linux:       "538fd53ebf1d2ac7172a08b00d0e31d89662cd47e754bdcabde081368edfe9df"
    sha256 cellar: :any, x86_64_linux:      "f4b16a72be322b5c8535f132a86e4a0064bd6bab6efb5227a6e369519a3c569b"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  uses_from_macos "libffi"

  deny_network_access!

  def fetch
    system "cabal", "v2-update"
    system "cabal", "v2-install", "--only-download", "--flags=executable", *std_cabal_v2_args
  end

  def install
    system "cabal", "v2-install", "--flags=executable", *std_cabal_v2_args
  end

  test do
    assert_match "<mn>2</mn>", pipe_output(bin/"texmath", "a^2 + b^2 = c^2", 0)
  end
end
