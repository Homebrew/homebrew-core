class Rc < Formula
  desc "Implementation of the AT&T Plan 9 shell"
  homepage "http://doc.cat-v.org/plan_9/4th_edition/papers/rc"
  url "https://web.archive.org/web/20200227085442/static.tobold.org/rc/rc-1.7.4.tar.gz"
  mirror "https://src.fedoraproject.org/repo/extras/rc/rc-1.7.4.tar.gz/f99732d7a8be3f15f81e99c3af46dc95/rc-1.7.4.tar.gz"
  sha256 "5ed26334dd0c1a616248b15ad7c90ca678ae3066fa02c5ddd0e6936f9af9bfd8"
  license "Zlib"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ac5175270dab427e207bc53ab5d47f6e3f28e8618b471df5a59dc2fd29719cb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "18c672af9e2e5d2e88ca29d57aec584aaa57daac97b9ac330d9f8164beb9ecce"
    sha256 cellar: :any_skip_relocation, monterey:       "02d867de600bc9787231892ab7de1dcd48caff4328cfd7d7c44e0a15eca6a677"
    sha256 cellar: :any_skip_relocation, big_sur:        "0e2ce85a1d122543d504138da5f09b88890ea175311572024b4e627bda9b3c65"
    sha256 cellar: :any_skip_relocation, catalina:       "ab871610d857058773a87f70ad995a5e02fdeb1e6fe3d699e2051892ce60af84"
    sha256 cellar: :any_skip_relocation, mojave:         "f14ceeb0e4315379e2052e39a24fafb529f841428b1a64e3009cfd62769b9e4a"
    sha256 cellar: :any_skip_relocation, high_sierra:    "c2ee55c504be78889adc7d0cba962528f995bf222dc77ce5a6b930210851294e"
    sha256 cellar: :any_skip_relocation, sierra:         "627e45477eabd5854e3c5f39af5290befd43d03b385d1b20f0ce4b49636fd2d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6623be4e09b3e283101e33938ec83f0c47d07ad164a30c5854a66d8e64e31447"
  end

  uses_from_macos "libedit"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--with-edit=edit"
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "Hello!", shell_output("#{bin}/rc -c 'echo Hello!'").chomp
  end
end
