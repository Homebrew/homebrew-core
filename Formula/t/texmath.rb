class Texmath < Formula
  desc "Haskell library for converting LaTeX math to MathML"
  homepage "https://johnmacfarlane.net/texmath.html"
  url "https://hackage.haskell.org/package/texmath-0.12.8.11/texmath-0.12.8.11.tar.gz"
  sha256 "ffe8a6638b616e47e61153ed3baef96c40c5a150a9a51cc7d55007da56c9dd7b"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/texmath.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b737f1922c2c5b565f908b49f927c4ba7d6a6196190216a7ec70b589e0edfd3b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f89fc54606830e96ea8cfa008d455604858e449470bd76c038c0ccf5a6cade6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5176446eb8f92691e9d1c04ce36c06dc10fd6624d4572de66e40a11389672ed9"
    sha256 cellar: :any_skip_relocation, sonoma:        "e12e7c443063e193e6cba1e836db8d5cb99fae386045bab93623d8cecc0dd6e0"
    sha256 cellar: :any_skip_relocation, ventura:       "837f26b56007ab08c67076d6417703ed5931afc2ebae803b70ffddbccf246b53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e210e901f43c6d9f3d049f17660ab73382d0f5f368fcaf201ecef5123f0fdb1"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args, "-fexecutable"
  end

  test do
    assert_match "<mn>2</mn>", pipe_output(bin/"texmath", "a^2 + b^2 = c^2")
  end
end
