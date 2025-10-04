class Yash < Formula
  desc "Yet another shell: a POSIX-compliant command-line shell"
  homepage "https://magicant.github.io/yash/"
  url "https://github.com/magicant/yash/releases/download/2.60/yash-2.60.tar.xz"
  sha256 "cc152f65221916c508e3ec013edda40028d1f77a9ca3dcf2489ee825fd746f75"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "d057067e099311aa17e39e27de5b8d427560c5f18c21841e1e56dfe6e05194ef"
    sha256 arm64_sequoia: "d07182c50d63b77312201b83e672d9c1c8f39510418412a77f8265baf482a222"
    sha256 arm64_sonoma:  "e0fe15a78087f63f05930f2e4d859b808c847e4481c8b1803d28e0876add8810"
    sha256 sonoma:        "4e116e5a3c4c45758dfac37d5f18703bb433bc3c67825dfd6f8ba48b69b0553f"
    sha256 arm64_linux:   "3891c2d9f393df01e31934ae653ca9b3c1d83af9a2ebe6dd685267ecfff85847"
    sha256 x86_64_linux:  "cbdb21f17951377d4b82635098a78be1489913077cc90a7d43da54a674f99747"
  end

  head do
    url "https://github.com/magicant/yash.git", branch: "trunk"

    depends_on "asciidoc" => :build
  end

  uses_from_macos "ncurses"

  on_macos do
    depends_on "gettext"
  end

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog" if build.head?

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"yash", "-c", "echo hello world"
    assert_match version.to_s, shell_output("#{bin}/yash --version")
  end
end
