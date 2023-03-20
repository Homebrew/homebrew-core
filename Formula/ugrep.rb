class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://github.com/Genivia/ugrep/archive/v3.11.0.tar.gz"
  sha256 "35ed29b251f71a7165b059b99b17cffe6947abebb8db025383aa9b897408e0be"
  license "BSD-3-Clause"

  bottle do
    sha256                               arm64_ventura:  "4170d4bd3b5a7843fb8b22a3d280f3c5cc1b76401fd87e10b9c77dcaef1a5a4e"
    sha256                               arm64_monterey: "8ad3a76fd231c97c192569c13d551c48ea44a19a6a5ea24e7d646cab0c33bb44"
    sha256                               arm64_big_sur:  "0ecb2ea7f1e4b025bbf91c8efab9d1cf731fe5d3e378cd60a0c66afe53368350"
    sha256                               ventura:        "e55e7e0c81a124bf9a3a7e260a597f28357dd3f9e5aba891fa95edb3293cc2c1"
    sha256                               monterey:       "178716e6044f87ea0f1a61efc2e020a39e5bf2db877b3c73a806f39301c949dd"
    sha256                               big_sur:        "f6678a0fa222b96d6cea4ff8043bd9acc98172d6ccdddd7aac0f2ad6dd1b2977"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5a8f7ba3d1a8b051e5810e46c3c2f2955410555edd92320636c1216025eb998"
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
