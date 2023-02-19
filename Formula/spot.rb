class Spot < Formula
  desc "Platform for LTL and ω-automata manipulation"
  homepage "https://spot.lre.epita.fr"
  url "http://www.lrde.epita.fr/dload/spot/spot-2.11.4.tar.gz"
  sha256 "91ecac6202819ea1de4534902ce457ec6eec0573d730584d6494d06b0bcaa0b4"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.lrde.epita.fr/dload/spot/"
    regex(/href=.*?spot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "dfd446959c92ffa4e9197409459d678d3f5f3dfc807d70af429b3abd00eaf13c"
    sha256 cellar: :any,                 arm64_monterey: "91d818b86373a7ea7457dc4ab940f3505a9d5735526667ffa5171d2a9246bab4"
    sha256 cellar: :any,                 arm64_big_sur:  "167ed3322e26397b3c4763c236df4a1ba682d05737094aec01422c70256efcb3"
    sha256 cellar: :any,                 ventura:        "6289210b5bc136a5c046e7c783fc57d7ad3f0c01b89b789e2aa62dbd1d0d8222"
    sha256 cellar: :any,                 monterey:       "63caabadce0b19a1841bac643a91766ff48c89bc41fbc3b63e1eada1d1bacc50"
    sha256 cellar: :any,                 big_sur:        "c7fea38fcde87107302070706f9cf408ab0557ec408527c83c25f32737c4e919"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee358551ed36c7f37a7b453984bce63b4420536ab48dad96fb3371f15f2a70a3"
  end

  depends_on "python@3.11" => :build

  fails_with gcc: "5" # C++17

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    system bin/"randltl -n20 a b c d | ltlcross 'ltl2tgba -H -D %f >%O' 'ltl2tgba -s %f >%O' 'ltl2tgba -DP %f >%O'"
  end
end
