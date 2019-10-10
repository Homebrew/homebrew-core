class Stgit < Formula
  desc "Push/pop utility built on top of Git"
  homepage "https://github.com/ctmarinas/stgit"
  url "https://github.com/ctmarinas/stgit/archive/v0.20.tar.gz"
  sha256 "87f590387d780db769d38f48afb052e3717ed88f9b60bd71c2c54d04e22b97e2"
  head "https://github.com/ctmarinas/stgit.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f8a902d90ef085fa02d55169da184884d72fa75adc13bf0948d574a4cada462f" => :mojave
    sha256 "8200c4517883268e2d6fda6988a3a5b19b37b762eabbb8c262841c0cc245d075" => :high_sierra
    sha256 "8200c4517883268e2d6fda6988a3a5b19b37b762eabbb8c262841c0cc245d075" => :sierra
  end

  def install
    ENV["PYTHON"] = "python" # overrides 'python2' built into makefile
    system "make", "prefix=#{prefix}", "all"
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    system "git", "init"
    (testpath/"test").write "test"
    system "git", "add", "test"
    system "git", "commit", "--message", "Initial commit", "test"
    system "#{bin}/stg", "init"
    system "#{bin}/stg", "log"
  end
end
