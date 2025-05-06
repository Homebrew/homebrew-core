class Whois < Formula
  desc "Lookup tool for domain names and other internet resources"
  homepage "https://github.com/rfc1036/whois"
  url "https://github.com/rfc1036/whois/archive/refs/tags/v5.6.0.tar.gz"
  sha256 "f871152e94f04de22e544e8627ff7a7ebc786fd1438e230cd5c28ea0a258a60c"
  license "GPL-2.0-or-later"
  head "https://github.com/rfc1036/whois.git", branch: "next"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ad4b2b51903dd2be1687b2dee169ae88218d0d56b8ab9371db27520acbf51652"
    sha256 cellar: :any,                 arm64_sonoma:  "3f2450e5a45fdf656a98cfbeca9714752204ec1543febcb817838e714eeb4e51"
    sha256 cellar: :any,                 arm64_ventura: "e2e91b1801ca6d24b26687ab6b6f739ffee9e6c6d0d9084d63ff1787781edc58"
    sha256 cellar: :any,                 sonoma:        "c9dc764ca90054c98107a3b882aaa0bcbb6a17af3cee408f33615d409e84b5ee"
    sha256 cellar: :any,                 ventura:       "b6656669d4a541e4922551b45e6228f401fe343fec89ea267ada8873e77f1a29"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2757c4eb3563c111d536170b80f4ba869ac6cbd744a716324d22b88a6af729d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "322f74c12adbd3e75f39930159502aaeff07e1eea639380291742fa1300c12a4"
  end

  keg_only :provided_by_macos

  depends_on "pkgconf" => :build
  depends_on "libidn2"

  def install
    ENV.append "LDFLAGS", "-L/usr/lib -liconv" if OS.mac?

    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    have_iconv = if OS.mac?
      "HAVE_ICONV=1"
    else
      "HAVE_ICONV=0"
    end

    system "make", "whois", have_iconv
    bin.install "whois"
    man1.install "whois.1"
    man5.install "whois.conf.5"
  end

  test do
    system bin/"whois", "brew.sh"
  end
end
