class Shelltestrunner < Formula
  desc "Portable command-line tool for testing command-line programs"
  homepage "https://github.com/simonmichael/shelltestrunner"
  url "https://hackage.haskell.org/package/shelltestrunner-1.9.0.1/shelltestrunner-1.9.0.1.tar.gz"
  sha256 "12d7f30a620c6bb77a763a3f269e8d1c031376bbc3a9cdc436dcd70a93b15aa8"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1947ef3fc74a969677b59348347a7342a81eae1c4fe2e6aa16e85123efc0cb58"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c63fd9f1d9c74e485032d73d2ce48f265835d1a72cbf827358bf95712fd8e132"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "52fc8a0cff43f070661d916d9808612e78ff1ee8013f6c7600df7bd068a08273"
    sha256 cellar: :any_skip_relocation, ventura:        "c59bb642f61e325cee17f6bee87943ab24fc98e948322a7d858ada87900d9519"
    sha256 cellar: :any_skip_relocation, monterey:       "f2f735a66a06b22159db137745f81adcce4be6b347459791bb2e6008090a95be"
    sha256 cellar: :any_skip_relocation, big_sur:        "79bb290de60861de679b09bb60e968aadbf260fbbc3c0abef853913b91794c81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1053f401e84298abcf98f2f09ec9d8fe18d6df60ad7ba8ce384c9400101b7c19"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

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
