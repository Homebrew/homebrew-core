class Texmath < Formula
  desc "Haskell library for converting LaTeX math to MathML"
  homepage "https://johnmacfarlane.net/texmath.html"
  url "https://hackage.haskell.org/package/texmath-0.13/texmath-0.13.tar.gz"
  sha256 "7d88b56e922471ff292d467af5fef690aaa0fae5c8cc30f55940b1035f2d57b1"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/texmath.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "adb3ffe49bb5f17dc8432722012fb451562937198ab75e9ad550c1e48738cec2"
    sha256 cellar: :any,                 arm64_sequoia: "0e45009df3593383e55eb88ab67acbcce97b9eeeb76144bd95b8d91fe7ed3fca"
    sha256 cellar: :any,                 arm64_sonoma:  "fca83b9e818bb4772d198e1566e5e59e9efd96a2d6066777dab48d148b997193"
    sha256 cellar: :any,                 arm64_ventura: "d404e82412439bb767daaf362bb8747228bf566a364a9108f827ef29efcd08a4"
    sha256 cellar: :any,                 sonoma:        "9e3b7ca35d478563f47531043d40fff08c18dc4694ace1057805c5abced66d45"
    sha256 cellar: :any,                 ventura:       "cc144c010f3874ffbdcf5bebc20320973173fe03181889fd2efc2208ef36fb0c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "31aa8321ba6ff65d37184614159aacda101df68c259b04b9d0c742bdb37e83f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d8c274e51f2ab57f2de89c32d12a3f2d38f3856039259ddb837b14a71b2e380"
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
