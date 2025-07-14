class Spot < Formula
  desc "Platform for LTL and ω-automata manipulation"
  homepage "https://spot.lre.epita.fr"
  url "https://www.lrde.epita.fr/dload/spot/spot-2.14.tar.gz"
  sha256 "cc267c96c96a40474669704114d02fb132ab30e8fa0ebca1a93f33e9d116024a"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.lrde.epita.fr/dload/spot/"
    regex(/href=.*?spot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "57f5609356b7f5a2109c1551414cc86b5b56418f936329e7d9c2e310a5145d91"
    sha256 cellar: :any,                 arm64_sonoma:  "8ecdbf4c8437644c39a4f63e15097367dd6ad5c8f2f85c4fb9d15a29560bd322"
    sha256 cellar: :any,                 arm64_ventura: "4c50c7b9f488c4185cae67dd6fa03f3ea7b4f9263a1be71437414ea24a9d67b3"
    sha256 cellar: :any,                 sonoma:        "0b5a312f9b9c64a5fd9d0dc87ba5e271f87f7e4270146d0030c07354f126f89b"
    sha256 cellar: :any,                 ventura:       "b6a5ad22ee50c859d6232ed18294a276dc626b0407240cfe74fb6bc1100f9400"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "28ee7a6ae455932d4e3314fe33b293e4fe4d8250fd35eb03e610d56c00c9d2f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b2cefcdda3b2fd454cbeed9dd6571cf8dca1dd26dc0f2cc01547af77011aa59"
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
