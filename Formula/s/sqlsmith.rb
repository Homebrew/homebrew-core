class Sqlsmith < Formula
  desc "Random SQL query generator"
  homepage "https://github.com/anse1/sqlsmith"
  url "https://github.com/anse1/sqlsmith/releases/download/v1.4/sqlsmith-1.4.tar.gz"
  sha256 "b0821acbe82782f6037315549f475368be3592cefe2c3c540f9cf52aa70d2f55"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "326d51752ce3c4712e27cb9bf6db9abf116204754c5f278fcbb03f4c01293f84"
    sha256 cellar: :any,                 arm64_ventura:  "3633918b467d037f1b745fbb66a775bcfec51e2f2e30308a3f41844ae119a08e"
    sha256 cellar: :any,                 arm64_monterey: "5d852c6394b08d56524a6f7c9f80cbea1cd196281c205d57a92d591a041e5938"
    sha256 cellar: :any,                 sonoma:         "fc55e87d89e7a7011417e7e383224b92d874b0971e3b6fb065d65ecede1bcf77"
    sha256 cellar: :any,                 ventura:        "478c8420ad11ab418f91cf6102b63944fcfe14bda089547a166e0b588d289439"
    sha256 cellar: :any,                 monterey:       "bcfe7b977b403628712ad310319f1c67d4f63301b0c575d17e7b7906c2573cd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10489e7e72cdbedb3099d68a4fc60e76392ac764a6c76a6a9b2e1e12b1fc0ee7"
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
    ENV.cxx11

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
