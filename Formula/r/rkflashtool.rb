class Rkflashtool < Formula
  desc "Tools for flashing Rockchip devices"
  homepage "https://sourceforge.net/projects/rkflashtool/"
  url "https://downloads.sourceforge.net/project/rkflashtool/rkflashtool-6.1/rkflashtool-6.1-src.tar.bz2"
  sha256 "2bc0ec580caa790b0aee634388a9110a429baf4b93ff2c4fce3d9ab583f51339"
  license "BSD-2-Clause"
  head "https://git.code.sf.net/p/rkflashtool/Git.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "f28fa9f142735da8b1dd19222e6ac5c696072e792a8e71fe9aeab969148fb5fd"
    sha256 cellar: :any,                 arm64_sequoia:  "5b977024f0938d2c9cf116821d05dfa00585f65d06b2158daadd6fdd99db991d"
    sha256 cellar: :any,                 arm64_sonoma:   "5ce2c505c683a80dc90ee03c57e100121f0cbec5e2805e0e85c74f916f1a5fbf"
    sha256 cellar: :any,                 arm64_ventura:  "5743c6c5935567e3988de6d16bc6f8cd80591ab5e0982f8594d97d48e63d8475"
    sha256 cellar: :any,                 arm64_monterey: "82f0530f1f49db73cdba8463cd10c870a33cb3f527a0d4441557caf8e112b2d6"
    sha256 cellar: :any,                 arm64_big_sur:  "385d2324a9740b034fa99eabe5325cde073cf301dcfb343dee7cf44bda109cbd"
    sha256 cellar: :any,                 sonoma:         "08198a36dd0408c2bc10a4ddeb5913a3282e2eed1f3ca0e10019a3765652926a"
    sha256 cellar: :any,                 ventura:        "5d00a439fe6a9c9f4b09ed9612e5b4536c1497e5baf33c0b95c06279b734fa6f"
    sha256 cellar: :any,                 monterey:       "7a80ef4c1271eb9bec9209bde3c1a0292e08bbeed130d290024e0877e3b9df9f"
    sha256 cellar: :any,                 big_sur:        "f3e27586cacbbe32859c4e29b681913204e1a52bd5a5761697edc37d1cc2d88c"
    sha256 cellar: :any,                 catalina:       "19915af37cac5f04cea6d0aa71a533ce6fd2a9aa549820286736b526e4be80cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "740d373e5d0bb55ce6cda1a391bda5cc95f75f61537f91f5de2b24b7d09cc722"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c38a8b6e2f2f2b8dd7b437c07916c5624076f472392a2899fbb3c397c07bb4a3"
  end

  depends_on "pkgconf" => :build
  depends_on "libusb"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"input.file").write "ABCD"
    system bin/"rkcrc", "input.file", "output.file"
    result = shell_output("cat output.file")
    result.force_encoding("UTF-8") if result.respond_to?(:force_encoding)
    assert_equal "ABCD\264\366\a\t", result
  end
end
