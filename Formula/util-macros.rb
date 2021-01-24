class UtilMacros < Formula
  desc "X.Org: Set of autoconf macros used to build other xorg packages"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/util/util-macros-1.19.3.tar.bz2"
  sha256 "0f812e6e9d2786ba8f54b960ee563c0663ddbe2434bf24ff193f5feab1f31971"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "dca6b81cec458f1d2fe9d367d91e9dc5f2459246b9e94fd77ed8ccf26c902c5d" => :big_sur
    sha256 "b87b4a899e8187eae34e6befe1f2b287035c036a3abd8ceca3eaf3d4190e1961" => :arm64_big_sur
    sha256 "298dfa88698206b08ce19e5daf66903da4a94e561ec639487c17b55c3d09ee3f" => :catalina
    sha256 "bd71cb44913a35fb4f8e63a0fd90229d8912d7af40f02c78b056cf72eb88b684" => :mojave
    sha256 "38d6cb7e6c900a555c5602af513224d346166e109b7226cc5b86cb51b9b55fe4" => :high_sierra
  end

  depends_on "pkg-config" => :test

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "pkg-config", "--exists", "xorg-macros"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
