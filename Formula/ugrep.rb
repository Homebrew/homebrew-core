class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://github.com/Genivia/ugrep/archive/v3.9.5.tar.gz"
  sha256 "7872dae0c016db53eaa6b0e8497fbac635e0fc80eb347b0f2142c3dba44ea18d"
  license "BSD-3-Clause"

  bottle do
    sha256                               arm64_ventura:  "14e1823d7c4d49cea77158d3ae3de7c4a2cdfdc1859f71e2cfd8dc951acc067c"
    sha256                               arm64_monterey: "217e3393e52733efe6c30a09e484ca4692a277c751a6fbd1a4e552f7868f51ec"
    sha256                               arm64_big_sur:  "37914d2a5e1de9366f1eba4dd118b2ace5ddf665b7e43f05b72078aba2d92e40"
    sha256                               ventura:        "c1f2098384fe65c30bedf1cf112879b22273f887b875edf0f1455032e028f6f4"
    sha256                               monterey:       "7aa317f9d3f90e8c26bd6b6a283b90fb87b20415541831c52697555f7c8a40e5"
    sha256                               big_sur:        "1a0c529255433f61a0e238f85a43fca2472ba8f9a0ab0f406e751142b2c254ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "029c9c2a3201c97ef9ae32534a18016cfd58ba6c9cb9d654a2fce817fcf2621b"
  end

  depends_on "pcre2"
  depends_on "xz"

  def install
    system "./configure", "--enable-color",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"Hello.txt").write("Hello World!")
    assert_match "Hello World!", shell_output("#{bin}/ug 'Hello' '#{testpath}'").strip
    assert_match "Hello World!", shell_output("#{bin}/ugrep 'World' '#{testpath}'").strip
  end
end
