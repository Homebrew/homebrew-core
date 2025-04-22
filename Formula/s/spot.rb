class Spot < Formula
  desc "Platform for LTL and ω-automata manipulation"
  homepage "https://spot.lre.epita.fr"
  url "https://www.lrde.epita.fr/dload/spot/spot-2.13.tar.gz"
  sha256 "0d0fe673cf1bc8933727bc8e0be7ba36901445211e2945ac73fb09835c81f4eb"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.lrde.epita.fr/dload/spot/"
    regex(/href=.*?spot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "13d7c8ac11db34a7a8b764a21ec432aee23e82f6c203993d82b5205ea3d24ad8"
    sha256 cellar: :any,                 arm64_sonoma:  "d68082eb2748cdd6319776cbd969f22d0c706a3fe6ffe03d43c61926f6495074"
    sha256 cellar: :any,                 arm64_ventura: "3479c7f105845b206b887e043302f428da3e0324050321461988db1a3a9a5a5e"
    sha256 cellar: :any,                 sonoma:        "b50160f4850825a805e49fb599804c358dd9622d4c2ad65b6d25a52c8912de2b"
    sha256 cellar: :any,                 ventura:       "2926815fb5ec93988f881c5958711fa8474947d948dc3071c3043c377da5786f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "79356cfd8b16223222424cff25e76f93b43c4038feadf3dc3933fcdccbe08675"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "790b0da5e46c005e3848272613832fd3d28563b09df8f4747cc93eabacfeda91"
  end

  depends_on "python@3.13" => :build

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    randltl_output = pipe_output("#{bin}/randltl -n20 a b c d", "")
    assert_match "Xb R ((Gb R c) W d)", randltl_output

    ltlcross_output = pipe_output("#{bin}/ltlcross '#{bin}/ltl2tgba -H -D %f >%O' " \
                                  "'#{bin}/ltl2tgba -s %f >%O' '#{bin}/ltl2tgba -DP %f >%O' 2>&1", randltl_output)
    assert_match "No problem detected", ltlcross_output
  end
end
