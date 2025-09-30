class Rc < Formula
  desc "Implementation of the AT&T Plan 9 shell"
  homepage "https://doc.cat-v.org/plan_9/4th_edition/papers/rc"
  url "https://web.archive.org/web/20200227085442/static.tobold.org/rc/rc-1.7.4.tar.gz"
  mirror "https://src.fedoraproject.org/repo/extras/rc/rc-1.7.4.tar.gz/f99732d7a8be3f15f81e99c3af46dc95/rc-1.7.4.tar.gz"
  sha256 "5ed26334dd0c1a616248b15ad7c90ca678ae3066fa02c5ddd0e6936f9af9bfd8"
  license "Zlib"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "7f1229b46bbcd4ea15a8cf6ed36601dc7e2a6e1a0436f4c6f946bc8611c236c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "64e670569da0f8330abe43a6f0cbb96266ae145b5324add5e71c658d44266745"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "384e3f48c4d39fc6b6eae5638514b345684dd3d8af6a14b73de894927083dcd5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ac5175270dab427e207bc53ab5d47f6e3f28e8618b471df5a59dc2fd29719cb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "18c672af9e2e5d2e88ca29d57aec584aaa57daac97b9ac330d9f8164beb9ecce"
    sha256 cellar: :any_skip_relocation, sonoma:         "ea0953b18bf78f8e7801c5f10fd7d0db032808ad1a167383edf769e5445008b4"
    sha256 cellar: :any_skip_relocation, ventura:        "95698c3547fa93a6e7ca971e63059e199faa741c86311ed8c5f929ea737a7a53"
    sha256 cellar: :any_skip_relocation, monterey:       "02d867de600bc9787231892ab7de1dcd48caff4328cfd7d7c44e0a15eca6a677"
    sha256 cellar: :any_skip_relocation, big_sur:        "0e2ce85a1d122543d504138da5f09b88890ea175311572024b4e627bda9b3c65"
    sha256 cellar: :any_skip_relocation, catalina:       "ab871610d857058773a87f70ad995a5e02fdeb1e6fe3d699e2051892ce60af84"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "a123be0cf463cf4550ba7d1c147d081006df55c7ac7e42d0840bca5c93828a76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6623be4e09b3e283101e33938ec83f0c47d07ad164a30c5854a66d8e64e31447"
  end

  deprecate! date: "2024-06-10", because: :repo_removed
  disable! date: "2025-06-21", because: :repo_removed

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
