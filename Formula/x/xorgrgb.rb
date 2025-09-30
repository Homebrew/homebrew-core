class Xorgrgb < Formula
  desc "X.Org: color names database"
  homepage "https://www.x.org/"
  url "https://xorg.freedesktop.org/archive/individual/app/rgb-1.1.0.tar.gz"
  sha256 "77142e3d6f06cfbfbe440e29596765259988a22db40b1e706e14b8ba4c962aa5"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "b4c43ac48800387feaa8d8d91d20977069578a7a13efdf0f4198b9a2eb763062"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "4cc8217eee8a4df6d597f4f6ab26718712256edd2bb0c5babcd646719ef052c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4148ce78e43c9aae8e75e639f5ebab603d20cd3aabd2e6421b71d967ac92aab7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "25ddac19c5361bd478b8c9ac4fab8210be7b8811f9b2edf586156604badfce23"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d9bb5c41b1ef76f04324db74b789330210d48be78c751ce4d0439e3b24a8b49"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "30ee14ffdbb2418cc39884775ba8b61ab19452cd3e4e95609d5c67ac2bf56013"
    sha256 cellar: :any_skip_relocation, sonoma:         "f65ce4c85f3617949dcb191a098b6fcf70c1815a76831753953734504ed3f6b0"
    sha256 cellar: :any_skip_relocation, ventura:        "39d8b12e69f0c07bfa6c78f682ed3160b81e0a986871821ec8871772f01bb5af"
    sha256 cellar: :any_skip_relocation, monterey:       "8a5606f9cdba7608ebc27042ced7920658ed39593a0338a0d02ccdd067290fe4"
    sha256 cellar: :any_skip_relocation, big_sur:        "db4fb9cf83a6fcc75036c4c3b3fdac6ac0fe47108311a1f83a35ebbe97e7f1e7"
    sha256 cellar: :any_skip_relocation, catalina:       "4f39373ce62247b2a47ff8f0a02fbdcb9af7e280aa7b1fa7443865024a0f561c"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "99fca7eae8c246f93d1f36f833c7031caf3d10a1f6273a556054396847f23679"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6c3eca82aa9624b8b521d9d0e5cec68b9391538717c36c4d438edc75bb0085f"
  end

  depends_on "pkgconf" => :build
  depends_on "util-macros" => :build
  depends_on "xorgproto" => :build

  def install
    args = %W[
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-silent-rules
    ]

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    assert_match "gray100", shell_output("#{bin}/showrgb").chomp
  end
end
