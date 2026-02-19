class Tree < Formula
  desc "Display directories as trees (with optional color/HTML output)"
  homepage "https://oldmanprogrammer.net/source.php?dir=projects/tree"
  url "https://github.com/Old-Man-Programmer/tree/archive/refs/tags/2.3.1.tar.gz"
  sha256 "621ff2b4faf214d7023143f6f9d496117c7c75131927837750b904140aff48a1"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8309cca93c32333eb9126d6145d91ef07593b2d1d8bafe2377cc63b8d856531f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d48fb693e457a81bcbaf7fa9d49af099045c4b741f83663b381e60d9d30ffff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff99aecd3c6b6f270776485f2895ea5ec148037670c496755929376ffe55709f"
    sha256 cellar: :any_skip_relocation, sonoma:        "26faf60db59f3d02114be757ad799935803b5c6a3191976153f864379fba1acf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f3d2674a733e6c3a8bb14aa7dc5f2017c520fa8680a4f40132b3398ba0993f36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65f6b991b200bd7a18db792923e309d2cde90f2627cec31a29af1bf0fd04b8dc"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}", "MANDIR=#{man}"
  end

  test do
    system bin/"tree", prefix
  end
end
