class Uudeview < Formula
  desc "Smart multi-file multi-part decoder"
  homepage "http://www.fpx.de/fp/Software/UUDeview/"
  url "http://www.fpx.de/fp/Software/UUDeview/download/uudeview-0.5.20.tar.gz"
  sha256 "e49a510ddf272022af204e96605bd454bb53da0b3fe0be437115768710dae435"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?uudeview[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "4a0021e8cbb12c07b7c46049e72d217530ed08c2474d57f145044ab7d24674d8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "519dcd3ca61e2c1eac14d1e1b15dc2b87492421fa77bfc396163b6882df7c298"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a58cd61413eb8e656d8395b63d1542e9f256d669d227b23d7cf0f70181a420c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "28d8a4e08275d26926e19c32a6ca833ed3a1c3969ea5126c4def92e72442e66d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c72240dbc205cb79229af479b8dc1774b4eb11d0ffad47391102e033be4bb07"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "93a098dc40d16b9785888c20c8d1707a62fe471938c99ea8074df042548cfed7"
    sha256 cellar: :any_skip_relocation, sonoma:         "cfbdefb80f1571aa3c8df28efe90f9a526ef1c936a51a2c0ea913e6da8447927"
    sha256 cellar: :any_skip_relocation, ventura:        "b82ecb8116e22c3c53af765f8da79f52aed9668182ff8b16d5a0523e739e51e7"
    sha256 cellar: :any_skip_relocation, monterey:       "0b5de5467dd832158645bca2006500fadaefc2e187819e883e9ff1a85bb60e64"
    sha256 cellar: :any_skip_relocation, big_sur:        "94426299f928e2c7985194d2a3f436112b2ca580945eacc82ad5047c619c2417"
    sha256 cellar: :any_skip_relocation, catalina:       "9b5990b5b763e90614bd2d074e670c20e834541d60082a4e78f90d67a65da5c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "59e22160ac8e39b4efe0f3c935141e1c24656875c142a69df72992d302c16c79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5cdd9748ec5c1baf9934bade72dd8a3eea06b632d0f1c49e57b682663bbb8371"
  end

  # fix implicit declaration, remove in release > 0.5.20
  patch do
    url "https://github.com/hannob/uudeview/commit/a8f98cf10e2c1ab883c31ed1292f16bfdd43ef33.patch?full_index=1"
    sha256 "1154a62902355105fc61cc38033b9284d488ca29b971ad18744915990ffb31ec"
  end

  patch do
    url "https://github.com/hannob/uudeview/commit/c54cb38ab71363647577fa98bedf4e0a3759c17b.patch?full_index=1"
    sha256 "44347fdb875d5a86909f6c2e6bd25f4325a34c7be83927b6fd5ba4cfe0bea46c"
  end

  patch do
    url "https://github.com/hannob/uudeview/commit/72a52709ea1c79c8747d2c0face50f03873d2f81.patch?full_index=1"
    sha256 "452788a9e81a0839b8bab924406db26542b529dedb8e8073df50eb299aae9dfc"
  end

  def install
    # Fix for newer clang
    ENV.append_to_cflags "-Wno-implicit-int" if DevelopmentTools.clang_build_version >= 1403
    ENV.append_to_cflags "-DSTDC_HEADERS"
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--disable-tcl"
    system "make", "install"
    # uudeview provides the public library libuu, but no way to install it.
    # Since the package is unsupported, upstream changes are unlikely to occur.
    # Install the library and headers manually for now.
    lib.install "uulib/libuu.a"
    include.install "uulib/uudeview.h"
  end

  test do
    system bin/"uudeview", "-V"
  end
end
