class Shelltestrunner < Formula
  desc "Portable command-line tool for testing command-line programs"
  homepage "https://github.com/simonmichael/shelltestrunner"
  url "https://hackage.haskell.org/package/shelltestrunner-1.10/shelltestrunner-1.10.tar.gz"
  sha256 "07bd3365fbbde9b4c80a3139792c30c1b1929736175fc207b4af1285bb97cbb0"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b7efdd51d33de7f1a6d0faf5b7cba05a2d6958ab6f2b953cf24dbd1f452dc2d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "14e0822f1871ee0db643fdffff2dd6a9caae2093f9b14035c2303a1666917263"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "582cff21d33d8c6b12327c308028ab04c6bdf522e9dabc44768bce82f044034d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "70426f971815a9fc20296d6cc1cf37e4ec61eb474022c6adb36c4689ac352ea9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "56a6a6ae7b4be0f2c3f44ff4e7890e56b2f361aff31952f507c65b115f10c421"
    sha256 cellar: :any_skip_relocation, sonoma:         "d1c8e59712ca832d1f567b8efe61ba73237281c196a904a70950a1d2cae2cd0e"
    sha256 cellar: :any_skip_relocation, ventura:        "68c4638e21a18a585339ec9bcdced418388d7763f003d430e77a4307643b7e3d"
    sha256 cellar: :any_skip_relocation, monterey:       "ed90af2f8aeba0417ae92c8aa1021b73f5ceaabe2b10f3161a0821439a00eead"
    sha256 cellar: :any_skip_relocation, big_sur:        "6f5766183b65e74e68caf0e5c2f507537458cfc1df434495c26828dcc1486dee"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "de2f4ffd77b89aa5ecbb7497a5ec9f03109aa934f8ce118b3344fb71c542f3cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "681f54b3d05958b695d5d9551d339c864f84a18639f8497a6923550df3bda337"
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
