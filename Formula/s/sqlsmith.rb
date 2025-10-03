class Sqlsmith < Formula
  desc "Random SQL query generator"
  homepage "https://github.com/anse1/sqlsmith"
  url "https://github.com/anse1/sqlsmith/releases/download/v1.4/sqlsmith-1.4.tar.gz"
  sha256 "b0821acbe82782f6037315549f475368be3592cefe2c3c540f9cf52aa70d2f55"
  license "GPL-3.0-only"
  revision 4

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d2eeed7e3a0447e19564eeca544e3fc0fc2331c5165f53b3145b865a76855745"
    sha256 cellar: :any,                 arm64_sequoia: "3d3b4d8a61c5b1012c165f83da60cad4a1de62653d24c378b42aa5505a986551"
    sha256 cellar: :any,                 arm64_sonoma:  "9f8a63bc4257b008ecc16ba3913c1e1b2b263f34f00e3385d45bc002f9221a11"
    sha256 cellar: :any,                 arm64_ventura: "d04086ed41c23bdeb8f3a2530e3ab40dfc49b48ee25ebfb0e7e98678ff6ed366"
    sha256 cellar: :any,                 sonoma:        "15bf710fd3748acb8aedb46336e91ee7646a2ba566f920ad71d6bcc36887228c"
    sha256 cellar: :any,                 ventura:       "4ba417966b98ed9413a2bc5770f33d2d185678c3662cc6783d4db3e9cc03221a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d6801038b4cff8cec72c060386fd5fba691188e4dfbe784de0085237dbfc9b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0097bee5057fa4d814dfa431ff700cfc87253c243bf1b806f6515b08c05b3b1b"
  end

  head do
    url "https://github.com/anse1/sqlsmith.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "autoconf-archive" => :build # required for AX_CXX_COMPILE_STDCXX_17
    depends_on "automake" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "libpq"
  depends_on "libpqxx"

  uses_from_macos "sqlite"

  def install
    ENV.append_to_cflags "-DNDEBUG"
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", "--disable-silent-rules", *std_configure_args
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
