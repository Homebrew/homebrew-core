class Spot < Formula
  desc "Platform for LTL and ω-automata manipulation"
  homepage "https://spot.lre.epita.fr"
  url "https://www.lrde.epita.fr/dload/spot/spot-2.12.tar.gz"
  sha256 "26ba076ad57ec73d2fae5482d53e16da95c47822707647e784d8c7cec0d10455"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.lrde.epita.fr/dload/spot/"
    regex(/href=.*?spot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e4c76f482118ead7179f160c066dfdf0ab3a2e1c7d00b2c90c00278921ab527f"
    sha256 cellar: :any,                 arm64_ventura:  "0820204a038373d059598cc87c0e65a9302abff79d89fe16b8726d746b6d06a8"
    sha256 cellar: :any,                 arm64_monterey: "af8c2ecf6ccf310913e30dd943b3020814adb5fd771e2884471f4b26e64c478b"
    sha256 cellar: :any,                 sonoma:         "ceefbedede95d7a74cecdce0b0c0616c3130a5fe72094be2590b37f0522d87f3"
    sha256 cellar: :any,                 ventura:        "b263cfe52f46515fb7ed5cf8bb60a480135bc3ba75e4cb167da98c456f648e54"
    sha256 cellar: :any,                 monterey:       "6c7200f7ad180a1a54caa6b19380c53934f7e6697a9891916a0b8945d3115992"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2729262b1b52510bf7f256f7d54bbb7b4a99e820c19f718947785ad33b541a72"
  end

  depends_on "python@3.12" => :build

  fails_with gcc: "5" # C++17

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
