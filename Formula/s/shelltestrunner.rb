class Shelltestrunner < Formula
  desc "Portable command-line tool for testing command-line programs"
  homepage "https://github.com/simonmichael/shelltestrunner"
  url "https://hackage.haskell.org/package/shelltestrunner-1.11/shelltestrunner-1.11.tar.gz"
  sha256 "b1742f8c0262034197faa879f1871848a3c404bc8a8aab706fbd053130d3414d"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9203ada94d9396bb88fe31f717229a5f636451797e0af2e8afec0855684a1d16"
    sha256 cellar: :any,                 arm64_sequoia: "57038337cd3c74ca18a64f229c8ad48621ab8cf02efe11f67a9bf34c059d9bb8"
    sha256 cellar: :any,                 arm64_sonoma:  "5999ff7d7e0805fd0abac81fc3fd3385d1725b20fce66d62b2987af70df2eca8"
    sha256 cellar: :any,                 sonoma:        "2f0bf32fac534b2fa34143ed7d67535890de2161c64aff2ddb7809c2df6f276a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "60bb7a211304833e0a87723390487acae78a771af2cf8fc48603400b683dd89f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b619cc0d9658c4c072ef6ff3164462cde54974faef0cc92527ca88cdfdb160a"
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
