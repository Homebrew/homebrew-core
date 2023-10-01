class UtilMacros < Formula
  desc "X.Org: Set of autoconf macros used to build other xorg packages"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/util/util-macros-1.20.0.tar.xz"
  sha256 "0b86b262dbe971edb4ff233bc370dfad9f241d09f078a3f6d5b7f4b8ea4430db"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2e8b1378e854636bb55cea97e384e9668391ff6a7ab98da5ce96ef52c59fb536"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d27b0b89a7376788a6a33f030d72f9bbc1397f7d21c2e672be950180ed35f3e9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d27b0b89a7376788a6a33f030d72f9bbc1397f7d21c2e672be950180ed35f3e9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d27b0b89a7376788a6a33f030d72f9bbc1397f7d21c2e672be950180ed35f3e9"
    sha256 cellar: :any_skip_relocation, sonoma:         "677f697c4dbdbe5f8b555dba3b5a9fa287f46b6965eca0f7696871f60905e34e"
    sha256 cellar: :any_skip_relocation, ventura:        "4e3314b61fccbf1b357ae51333f1c228dca6bcee87dcc218fe843fbbc0d55dd6"
    sha256 cellar: :any_skip_relocation, monterey:       "4e3314b61fccbf1b357ae51333f1c228dca6bcee87dcc218fe843fbbc0d55dd6"
    sha256 cellar: :any_skip_relocation, big_sur:        "4e3314b61fccbf1b357ae51333f1c228dca6bcee87dcc218fe843fbbc0d55dd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d27b0b89a7376788a6a33f030d72f9bbc1397f7d21c2e672be950180ed35f3e9"
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
