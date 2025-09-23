class Spot < Formula
  desc "Platform for LTL and ω-automata manipulation"
  homepage "https://spot.lre.epita.fr"
  url "https://www.lrde.epita.fr/dload/spot/spot-2.14.1.tar.gz"
  sha256 "25df8a6af4e4bb3ae67515ac98e3d37c4303a682e33aaa66e72d74b39459a530"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.lrde.epita.fr/dload/spot/"
    regex(/href=.*?spot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "612b69afc32ed930b14863cbfe0f6b4d346254a2952ab8cd2d0722e4b0669d0f"
    sha256 cellar: :any,                 arm64_sequoia: "d3d54bc17d03f479edbce15c34a9b079728a67c2c052128ec42a13bc229c9d1f"
    sha256 cellar: :any,                 arm64_sonoma:  "0b3c3b88c6fd03b54c639ea589d9de587fb4847f493a7d4d2417bbf94b4e8d84"
    sha256 cellar: :any,                 arm64_ventura: "1c371505759480b7343dc251b3a0ae29f3e054d7c54eb20b49af6fd4e4ae27f2"
    sha256 cellar: :any,                 sonoma:        "9c4dfae8366884aca59930623ea9c48b5c987c2434e413dc135cc2dc24168f7d"
    sha256 cellar: :any,                 ventura:       "a6664a905876cbe65c8da292516dbc57e70dfd2bcbf53516fbf30c0a52fe22de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf134747979cdf0d7176e01f9923a10636c475a369bd08efeddd1b73dbc66920"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f01a5df70b037f1a613b78809d64bc61092e8377c71334271789b602dbeb909b"
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
