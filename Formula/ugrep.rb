class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://github.com/Genivia/ugrep/archive/v3.9.2.tar.gz"
  sha256 "3416267ac5a4dd2938ca91e7bd91db958d65510c9fd33b221f067bd3c6b3fc6a"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_ventura:  "32998ad357de246d98c7f04317e540bb20631848b3867d97d7d70361ef04f57a"
    sha256 arm64_monterey: "c02e298d5858fd7aa8d8307cb52c29c086e360ba2b219d71a1d7c59a27ba6ddc"
    sha256 arm64_big_sur:  "154cd0420579b2e0203a3b6dfd44943d9eb125e2adf2037bbf90113e3fe0dbe4"
    sha256 ventura:        "a83296acd870e799b6fd6d9b0927a758cf201cd4a8c021cbd5a68935a2bd3e0f"
    sha256 monterey:       "b1a2c618f1f404372ac838d0a4fe890233111e3118290629bcafa65578dbb682"
    sha256 big_sur:        "81d7214cdfaec0060179bb3f02e24edb45f390c0f4bf0bbe5f4a05dd30b36477"
    sha256 catalina:       "db2e8624cfde4ee3d23007b365377b9d545d6f26a3b91ca28c8d9861b0259ba3"
    sha256 x86_64_linux:   "411ab9ae62e0647f2bcc42fbbb3cffcc256349bce98eec656992a4ef4369c3a0"
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
