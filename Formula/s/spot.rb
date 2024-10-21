class Spot < Formula
  desc "Platform for LTL and ω-automata manipulation"
  homepage "https://spot.lre.epita.fr"
  url "https://www.lrde.epita.fr/dload/spot/spot-2.12.1.tar.gz"
  sha256 "5477c08d4e1d062f164c2e486a83556925d07d70f2180de706af7aa949c6ff5c"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.lrde.epita.fr/dload/spot/"
    regex(/href=.*?spot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "13273a424546330dcb88457667df63bcc4441ba52748f1a2f998847e21579fe1"
    sha256 cellar: :any,                 arm64_sonoma:  "3f3e6b30ada8fca2095c2f9e48543a7efb06a283c0c0be2fe58f16d9d77d058f"
    sha256 cellar: :any,                 arm64_ventura: "8d0eeb9eb003a39959a556cc47c3c5680ec077a8cab4527fc2fb5126d96892eb"
    sha256 cellar: :any,                 sonoma:        "14f6bc12870fb15b58cfee446186261c7acbfb785ff14fca2cd01377b71d1036"
    sha256 cellar: :any,                 ventura:       "072a39a85251c944035b33d5463b7af0ffdc9b081014825a78a99c4d5f88c686"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e91723e2bf847484701af072c3bc4cd85aa22bfcde4b6b590a849e62c15ff7a4"
  end

  depends_on "python@3.13" => :build

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
