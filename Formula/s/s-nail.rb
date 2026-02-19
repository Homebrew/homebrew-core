class SNail < Formula
  desc "Fork of Heirloom mailx"
  homepage "https://www.sdaoden.eu/code.html"
  url "https://www.sdaoden.eu/downloads/s-nail-14.9.25.tar.xz"
  sha256 "20ff055be9829b69d46ebc400dfe516a40d287d7ce810c74355d6bdc1a28d8a9"
  license all_of: [
    "BSD-2-Clause", # file-dotlock.h
    "BSD-3-Clause",
    "BSD-4-Clause",
    "ISC",
    "HPND-sell-variant", # GSSAPI code
    "RSA-MD", # MD5 code
  ]

  livecheck do
    url :homepage
    regex(/href=.*?s-nail[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:    "694010922da95400d2613164c134a3820f1db8aec0f23267915c490110e5cc6b"
    sha256 arm64_sequoia:  "38bef1a5706829568846930febb7f0544d2ae65bf05bc099e3d0d0cec63ab89e"
    sha256 arm64_sonoma:   "84aaf90c9666df6a015cacc2e9f7598bebe010904e7c67432a7cd647ceaf22f3"
    sha256 arm64_ventura:  "d12aaf7bef7b6b6df01c85628df68acee52d95a6581c6f10c1f4cf3e8e88ec86"
    sha256 arm64_monterey: "64a71a850ff155293b889b74aaf448cafd3a7cb0e4dbf5e907374cf3be97073d"
    sha256 sonoma:         "1233acc467105675251c16c62d77185f9fa1adcc39ac8020498ed34865b6669d"
    sha256 ventura:        "0f32c32dabfb374441e1d57a3e3cba11f98657a800cfc188f788599c120c9c20"
    sha256 monterey:       "251e79282a3a1bca628513e03693484386a8efd3df7693390a41bec94ce9c995"
    sha256 arm64_linux:    "9ee474cf7423192b3351e52cf64a77c20caa55465c3b7720e0cd66c37ada9705"
    sha256 x86_64_linux:   "803cfa3485cc7bb7f528290ad09612233cb79e68ecb66f75477ac6d015d24636"
  end

  depends_on "libidn2"
  depends_on "openssl@3"

  uses_from_macos "ncurses"

  def install
    system "make", "CC=#{ENV.cc}",
                   "C_INCLUDE_PATH=#{Formula["openssl@3"].opt_include}",
                   "LDFLAGS=-L#{Formula["openssl@3"].opt_lib}",
                   "VAL_PREFIX=#{prefix}",
                   "OPT_DOTLOCK=no",
                   "config"
    system "make", "build"
    system "make", "install"
  end

  test do
    timestamp = 844_221_007
    ENV["SOURCE_DATE_EPOCH"] = timestamp.to_s

    date1 = Time.at(timestamp).strftime("%a %b %e %T %Y")
    date2 = Time.at(timestamp).strftime("%a, %d %b %Y %T %z")

    expected = <<~EOS
      From reproducible_build #{date1.chomp}
      Date: #{date2.chomp}
      User-Agent: s-nail reproducible_build

      Hello oh you Hammer2!
    EOS

    input = "Hello oh you Hammer2!\n"
    output = pipe_output("#{bin}/s-nail -#:/ -Sexpandaddr -", input, 0)
    assert_equal expected, output.chomp
  end
end
