class Spot < Formula
  desc "Platform for LTL and ω-automata manipulation"
  homepage "https://spot.lre.epita.fr"
  url "https://www.lrde.epita.fr/dload/spot/spot-2.14.3.tar.gz"
  sha256 "a0cc89fa716c35a3d7f3272fdbb028841560e671b9958c053870292daf88dd21"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.lrde.epita.fr/dload/spot/"
    regex(/href=.*?spot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "5ebf9188289b7edc8558dd316e429a07723a4fa592872c1c5f3b4fb0c79e2c4a"
    sha256 cellar: :any,                 arm64_sequoia: "89d678e29946e21be3799d22cb1a4b20b02a1d02d8be3f257b7d0ec4766a236f"
    sha256 cellar: :any,                 arm64_sonoma:  "376c92cbec2cd6fedf96112acceb8c75b62d1b6a56438c5c7be10158c0dd408b"
    sha256 cellar: :any,                 sonoma:        "ff17fef6f1a6f44da93594979fc2562b01fe8ce3aa8619b4b459931643b17f45"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5dcd58f0db3d6df6688c4151e193f82d1df6833053bde2754c1e33647d682957"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "515225f54b9e59ed573016bf29650ce5cda88d0dfcc83be0a978e08b32edd374"
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
