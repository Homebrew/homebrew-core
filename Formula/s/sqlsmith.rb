class Sqlsmith < Formula
  desc "Random SQL query generator"
  homepage "https://github.com/anse1/sqlsmith"
  url "https://github.com/anse1/sqlsmith/releases/download/v1.4/sqlsmith-1.4.tar.gz"
  sha256 "b0821acbe82782f6037315549f475368be3592cefe2c3c540f9cf52aa70d2f55"
  license "GPL-3.0-only"
  revision 3

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b78fc015203026a02f5c1e131507e3b97dcea93e72f35922f1f6f80b6f85489e"
    sha256 cellar: :any,                 arm64_ventura:  "64a31beb20590bffa1042cd8aee60abc1b9222ac8db256c0a7f6d464c8df13a4"
    sha256 cellar: :any,                 arm64_monterey: "9075fd2c902eb4bd9ab50a98ee8edbfe99313815d4609dce2d39cfbf62e04a26"
    sha256 cellar: :any,                 sonoma:         "71604917d8811ed0b57ccc65a17e4dc3b15af78e4eaa942801c9663fa23db13a"
    sha256 cellar: :any,                 ventura:        "4b727404b5aa16a6d582e86ac71269999635a1cc15d82eddc55c5fbdead99993"
    sha256 cellar: :any,                 monterey:       "26318bcdd84afd83d1f20e7796d0f03e8d2413d47f78cef9785d63143852db1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c1bae969727cf221a55317071ff5eee0c24858f161c263be6950257ee9e8858c"
  end

  head do
    url "https://github.com/anse1/sqlsmith.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "autoconf-archive" => :build # required for AX_CXX_COMPILE_STDCXX_17
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libpqxx"

  uses_from_macos "sqlite"

  def install
    ENV.append_to_cflags "-DNDEBUG"
    system "autoreconf", "-fvi" if build.head?
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "install"
  end

  test do
    cmd = %W[
      #{bin}/sqlsmith
      --sqlite
      --max-queries=100
      --verbose
      --seed=1
      2>&1
    ].join(" ")
    output = shell_output(cmd)

    assert_match "Loading tables...done.", output
    assert_match "Loading columns and constraints...done.", output
    assert_match "Generating indexes...done.", output
    assert_match "queries: 100", output
    assert_match "impedance report:", output
  end
end
