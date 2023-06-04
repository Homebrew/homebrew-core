class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://github.com/Genivia/ugrep/archive/v3.12.1.tar.gz"
  sha256 "a442ac9c0961746374d0627e6ec52d5c6250541640aeb9a698eb40382d0ec44c"
  license "BSD-3-Clause"

  bottle do
    sha256                               arm64_ventura:  "d4cc66e53dfcd5cd6cc457c4c0c8c84080d0b4c50e6fec3f51f88365e97f9b01"
    sha256                               arm64_monterey: "bcdd4e44be4277cc6349a0e1b63c3bf794872328cf7a84239ba36ccfafc4b859"
    sha256                               arm64_big_sur:  "1eb9c83cadfbed9b99810786b2f8f4f4dd23ca9de4c148753fd5c2626436132a"
    sha256                               ventura:        "c52bba758c77f67b1a78fed21fee7ee229e64b45f1a8cc5cf9a8dff23ccb67e1"
    sha256                               monterey:       "9db9376aeade27180a16a9ba4268755d5019b03b6bc358f69fb084d79ec4fa89"
    sha256                               big_sur:        "f4b997a4265e919120e811ef6071e2f15e2200f4e6d9e320ccd2c7129c558809"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "282fa4fc806b35c79e8d7def06152c23e58c847a0f506602839367e80b37dbc5"
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
