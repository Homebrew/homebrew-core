class UtilMacros < Formula
  desc "X.Org: Set of autoconf macros used to build other xorg packages"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/util/util-macros-1.20.2.tar.xz"
  sha256 "9ac269eba24f672d7d7b3574e4be5f333d13f04a7712303b1821b2a51ac82e8e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "418d29093fca0889e64ecc830bd8d987269774aba25d302cf959338acc1363ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "418d29093fca0889e64ecc830bd8d987269774aba25d302cf959338acc1363ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "418d29093fca0889e64ecc830bd8d987269774aba25d302cf959338acc1363ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "61e34714606b0ade8be0c48e199d42bde8a7b0894af880d0abac628647438a85"
    sha256 cellar: :any_skip_relocation, ventura:       "61e34714606b0ade8be0c48e199d42bde8a7b0894af880d0abac628647438a85"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1667d87ebab1bae1e48e9ef068534059be1bc7398cea4a39de35cb850109bd79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "418d29093fca0889e64ecc830bd8d987269774aba25d302cf959338acc1363ac"
  end

  depends_on "pkgconf" => :test

  def install
    args = %W[
      --disable-silent-rules
      --sysconfdir=#{etc}
      --localstatedir=#{var}
    ]

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    assert_equal version.to_s, shell_output("pkgconf --modversion xorg-macros").chomp
  end
end
