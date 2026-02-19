class Testdisk < Formula
  desc "Powerful free data recovery utility"
  homepage "https://www.cgsecurity.org/wiki/TestDisk"
  url "https://www.cgsecurity.org/testdisk-7.2.tar.bz2"
  sha256 "f8343be20cb4001c5d91a2e3bcd918398f00ae6d8310894a5a9f2feb813c283f"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.cgsecurity.org/wiki/TestDisk_Download"
    regex(/href=.*?testdisk[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e329a6e62f3a3a45d211f502f2d9286e1f33740bae6b63777166f18b2051138c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eab017ff1b655d0013b12559928b9fd7ed92605a448c8a460e5432ebc3cef380"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a3bc8238eebd4b4937d900bb715224978923a54918f2dc04346ba90acc71895"
    sha256 cellar: :any_skip_relocation, sonoma:        "381c8a908f2ed4becfa397a6115690108a5e830a331c2def84b7e2f774bf25f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "46e93192d84e0d2321b54d436b1cae92a578b30a062a117ee19184ca1fdf8942"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89f05af94ead3d6dacecac6bab3ecbf64fcb3b3147504a1018a620134d211e53"
  end

  uses_from_macos "ncurses"

  on_linux do
    depends_on "util-linux"
    depends_on "zlib-ng-compat"
  end

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args.reject { |s| s["disable-debug"] }
    system "make", "install"
  end

  test do
    path = "test.dmg"
    cp test_fixtures(path + ".gz"), path + ".gz"
    system "gunzip", path
    system bin/"testdisk", "/list", path
  end
end
