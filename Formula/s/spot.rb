class Spot < Formula
  desc "Platform for LTL and ω-automata manipulation"
  homepage "https://spot.lre.epita.fr"
  url "https://www.lrde.epita.fr/dload/spot/spot-2.14.5.tar.gz"
  sha256 "8703d33426eea50a8e3b7f4b984c05b8058cbff054b260863a1688980d8b8d19"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.lrde.epita.fr/dload/spot/"
    regex(/href=.*?spot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8e2ae80fe051f56744bd18c1fb98c7f95da877d5be0cd0ae5abeaa7172d277d3"
    sha256 cellar: :any,                 arm64_sequoia: "7e9253e66c7e43d9085dcd6bad09be7840034a0aac1ec10053532e0bb1cdefc4"
    sha256 cellar: :any,                 arm64_sonoma:  "7aa52c9c2d1eacbbef5afd551871e55683373b2a830af50eec9f1bc39767e343"
    sha256 cellar: :any,                 sonoma:        "51c5717d7b691cf3772606962d492c663bb750d4622b43f01737c07a91840250"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "31a06e35f69b57052208f0ae22f71afbbc9101ac4a275e4b21e4241e2b07c97b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31c53a6f56b6f0fdb2855302518280692bf5e50cd6ae7cdef7fa3c2029a583c7"
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
