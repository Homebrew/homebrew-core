class Spot < Formula
  desc "Platform for LTL and ω-automata manipulation"
  homepage "https://spot.lre.epita.fr"
  url "https://www.lrde.epita.fr/dload/spot/spot-2.15.1.tar.gz"
  sha256 "65013a2edf3f314854d7619888145f52c8dd36bfd27894d9db9b272d9a16ce4b"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.lrde.epita.fr/dload/spot/"
    regex(/href=.*?spot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e010d364f9d17297ee1e337e93b93668170a84afcfdb160f9e87aabbeef528fb"
    sha256 cellar: :any,                 arm64_sequoia: "1427e29e5eb6a4a0cfb3cec84d6ebcd15c5569bc905b4641950317cf0e08bd66"
    sha256 cellar: :any,                 arm64_sonoma:  "0b1ca9fa345ef9f3e5aa2e8ccf0d71d4ff248c4ab35e8f7beaa8ecf7b0d166e1"
    sha256 cellar: :any,                 sonoma:        "ab85af1ccfea03b126c66a0f0ae1f42c03b095ebf32f2d10898867ba0e4d6cb0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aae9243c82ee4ca4cbdd565e8c458e1b265d1892282b511792c007f76ed17996"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4754a6b50687310303b786546b8d5937ba2274f96ebe4638b8fd992e6c90796d"
  end

  depends_on "python@3.14" => :build

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
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
