class UtilMacros < Formula
  desc "X.Org: Set of autoconf macros used to build other xorg packages"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/util/util-macros-1.20.1.tar.xz"
  sha256 "0b308f62dce78ac0f4d9de6888234bf170f276b64ac7c96e99779bb4319bcef5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "eb3545f4823ce88d8d452be96d91d6b6ffbdbd7fa3232854ef6b7c4185ee8465"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2b4af09c7a852f609925d9a8ead68653d67f80e2452000ec0e54b372d9b4b0cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b4af09c7a852f609925d9a8ead68653d67f80e2452000ec0e54b372d9b4b0cf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b4af09c7a852f609925d9a8ead68653d67f80e2452000ec0e54b372d9b4b0cf"
    sha256 cellar: :any_skip_relocation, sonoma:         "696cf4c4a3f599b3572b2626958c668f0188f14af306cc777c4ab878e2f3fb3f"
    sha256 cellar: :any_skip_relocation, ventura:        "696cf4c4a3f599b3572b2626958c668f0188f14af306cc777c4ab878e2f3fb3f"
    sha256 cellar: :any_skip_relocation, monterey:       "696cf4c4a3f599b3572b2626958c668f0188f14af306cc777c4ab878e2f3fb3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b4af09c7a852f609925d9a8ead68653d67f80e2452000ec0e54b372d9b4b0cf"
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
