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
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia:  "52535012f25283205af92afbf333d0926e9910c9a05ae96708a4c4eb018cffeb"
    sha256 cellar: :any,                 arm64_sonoma:   "243870da20774ace2bb0fb2d151d7c13c17476f6709778fcad73d3daf775c10e"
    sha256 cellar: :any,                 arm64_ventura:  "a73bf5da9f72029581e9d94f8881cd68a5d76619070c072a3eaba963960dff7a"
    sha256 cellar: :any,                 arm64_monterey: "17f2807af8ea421abfbfd1006324003e830a635bfb6c72157643e229b497882b"
    sha256 cellar: :any,                 sonoma:         "ac49565ca4eebece4c71d1f6e7b3b1267e24c5256846e3c35086e70610eab688"
    sha256 cellar: :any,                 ventura:        "8b6244b263a7099ec2430513a8f8514fcd471ddf3d93a5f3d947c3483592b5a5"
    sha256 cellar: :any,                 monterey:       "531e89b0c6fdb52816932863d4e70e670abe9d0bdf183fb2bbd9273e2391a3ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3365775225260f0de10d4196edd0b0499041c52b4e3dc4838ba271c5970136f"
  end

  head do
    url "https://github.com/anse1/sqlsmith.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "autoconf-archive" => :build # required for AX_CXX_COMPILE_STDCXX_17
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libpq"
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
