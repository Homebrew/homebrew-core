class Shelltestrunner < Formula
  desc "Portable command-line tool for testing command-line programs"
  homepage "https://github.com/simonmichael/shelltestrunner"
  url "https://hackage.haskell.org/package/shelltestrunner-1.11/shelltestrunner-1.11.tar.gz"
  sha256 "b1742f8c0262034197faa879f1871848a3c404bc8a8aab706fbd053130d3414d"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "ec8369c12e98173330963627f5a46010b3f21cf9a63791fd8fd34f723b23c173"
    sha256 cellar: :any, arm64_sequoia: "eebdab863d9d345eea451899f791305c7acc161c9d74bb123dc29f1abe05c546"
    sha256 cellar: :any, arm64_sonoma:  "e2e0b72326d3ac35e5efb64503dc8b42d5cb195070942833a55abbfca32895f8"
    sha256 cellar: :any, sonoma:        "004b1ec0e9f7eee9338fa395db8c854797fcda39e228425afb646e6e32444f4b"
    sha256 cellar: :any, arm64_linux:   "9df6d6d671e6f85738c64344f239a20d8394c13a62d33f59ef1936135a492395"
    sha256 cellar: :any, x86_64_linux:  "7a18dcec794974fdc9e79fb999fb6f30ce58549adf0e21842660a47e010cd4b9"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  uses_from_macos "libffi"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    (testpath/"test").write "$$$ {exe} {in}\n>>> /{out}/\n>>>= 0"
    args = "-D{exe}=echo -D{in}=message -D{out}=message -D{doNotExist}=null"
    assert_match "Passed", shell_output("#{bin}/shelltest #{args} test")
  end
end
