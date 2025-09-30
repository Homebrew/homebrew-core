class Tnef < Formula
  desc "Microsoft MS-TNEF attachment unpacker"
  homepage "https://github.com/verdammelt/tnef"
  url "https://github.com/verdammelt/tnef/archive/refs/tags/1.4.18.tar.gz"
  sha256 "fa56dd08649f51b173017911cae277dc4b2c98211721c2a60708bf1d28839922"
  license "GPL-2.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "44529baf2a4c808692492827a1e241d50d4664afb347e2c9efbd174459e77dfa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "83bd5a4cd7402252e5b3652cb5660aa5ec15527623608cc08556dbb1c6b14b15"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3fa9d1e41b5eae6e4190c2d2a3a3c19c2ab8bffd9424aa69b6e0ea1f55d04f6e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "920a01f591be96275e201cfd5dc6e34014cfe036cf255ad5c67daa3167f327e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1201de0e009993b46a273968cbcd8c9a43c468c30310807712052d398c7034f2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4e6bdd57047af524d3efd157858a47d857a12fc110142a3d94bd47c8552fdc0a"
    sha256 cellar: :any_skip_relocation, sonoma:         "e44086c7acb426a7cab55fa86e6b38ac9e399b75ee5f962d0b0332c1dfa6e211"
    sha256 cellar: :any_skip_relocation, ventura:        "cd8e00e27d2857404867233b70ccbe5f991ca50c03d9660533a0b60de47db438"
    sha256 cellar: :any_skip_relocation, monterey:       "a79b4c0a54e6b4454281c5f40a500e7f3923588815374f28684e9d0fc53adda4"
    sha256 cellar: :any_skip_relocation, big_sur:        "37ce4eac19eaa6e7111d7ef7897595ac71ebb58f6d7da32dc309bb02bc5a90b4"
    sha256 cellar: :any_skip_relocation, catalina:       "ff92eb820b2efae9e87e42491a590601f400160f27ea2804b176b02b1648be66"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "93e86704b1d441a799e40b3f446e612a42f303bc7f00e1aa8fae44f97ea5d0c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a295c834fdb6ae952708260a5a49bfd9771538ca5b6eda6014eeccaa1956dbbd"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"tnef", "--version"
  end
end
