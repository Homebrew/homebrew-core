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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "4ef939fc1be6e7d281fbc1340258bf82710eec158535d76ea6ca5290ff1fd9a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "1726a772720eff30c93476660a6ce2ee68c89b400e5247086ebf6b77b27c1b84"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "76fe31d9656985c415243cdb7ab5a1f65696f8bcebebd2f2a1308517e870f205"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "843c14d99607b293dcbe021687205437023bc8a5a57813bac8214d2abe578179"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b599705f681955d6fcd094b44777dc29fa6b45886b3d47bef910579dbfd837de"
    sha256 cellar: :any_skip_relocation, sonoma:         "8db633d609f8cd60846d7f0f580a752f2c4959a89c2cf5c2150fbec8c1db1500"
    sha256 cellar: :any_skip_relocation, ventura:        "3acf40e8f1a8649610455147ad0c1e3d9400882b9df1e5ba247b4ac19fdd87ec"
    sha256 cellar: :any_skip_relocation, monterey:       "e0c1d8dc41bac15b27c7dddaa1cc375e0205cba23e002a5dde0db8bd4251f291"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "9e80b679b3c59a860ea10e68c79ab7de1acc58c4e2218956cd99f6bab22fa58e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0624bb8d366a5835a037928e92fcbdd998e0df181a7a1b41458f10d5c0f84231"
  end

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_linux do
    depends_on "util-linux"
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
