class Tofrodos < Formula
  desc "Converts DOS <-> UNIX text files, alias tofromdos"
  homepage "https://www.thefreecountry.com/tofrodos/"
  url "https://www.thefreecountry.com/tofrodos/tofrodos-1.8.3.zip"
  sha256 "44d76fb024164982aa5e166c1a3c29fa7555c9e0ee8e196cc52595c57a4b55dc"
  license "GPL-2.0-only"

  livecheck do
    url :homepage
    regex(/href=.*?tofrodos[._-]v?(\d+(?:\.\d+)+)\.(?:t|zip)/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ed51d90d1c7e5a548f75ee9aeac84b5f11dd5f1ee683674b4b2edec39b053de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f5b16d880a34a9f8f8bcf3c3a5520affe8356fcf24854fd23e09b07ee1b2de8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55ad657b7068a6106e846311ca92abbbf94ed236d7c48b263a25eabc95acc434"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ef7cc693cfb4c53110c3771bfd4c3843a314ad610417c4e47cf3af5ec4ef6d09"
    sha256 cellar: :any_skip_relocation, sonoma:        "fbbecca042307e05f058ab8f8d95a97340cc7111114041581059f6815129f15b"
    sha256 cellar: :any_skip_relocation, ventura:       "e4ea589dde1039b1732d7ada4b8f817b30d90aea37a3ece09c520316505688c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "97e7b249efc5aea737734daf57e21300701accc3f70419030be49ff039ceb50a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6883c12d2a042937a3e93beacc2350d65dcdc5c99230b8325ef022488552a14b"
  end

  def install
    mkdir_p [bin, man1]

    system "make", "-C", "src", "all"
    system "make", "-C", "src", "BINDIR=#{bin}", "MANDIR=#{man1}", "install"
  end

  test do
    (testpath/"test.txt").write <<~EOS
      Example text
    EOS

    shell_output("#{bin}/todos -b #{testpath}/test.txt")
    shell_output("#{bin}/fromdos #{testpath}/test.txt")
    assert_equal (testpath/"test.txt").read, (testpath/"test.txt.bak").read
  end
end
