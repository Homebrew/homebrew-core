class Whois < Formula
  desc "Lookup tool for domain names and other internet resources"
  homepage "https://github.com/rfc1036/whois"
  url "https://github.com/rfc1036/whois/archive/refs/tags/v5.6.6.tar.gz"
  sha256 "43d3b3cc64c75e8bd10aee6feff3906e9488ed335076d206e70f3b25bf644969"
  license "GPL-2.0-or-later"
  head "https://github.com/rfc1036/whois.git", branch: "next"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9b65a782bd5207b250ef0fb7754658493326c1d4b72bd5f89bfdbb815795ebd7"
    sha256 cellar: :any,                 arm64_sequoia: "76cd02aff01bd38c1cb6363a0bb418d5582330754135f982d57044b6bcae0028"
    sha256 cellar: :any,                 arm64_sonoma:  "c0660ae80290d002a9acb72bf7c1bbd62983616f96f71eb00078b1596ceb75f6"
    sha256 cellar: :any,                 sonoma:        "fa5e4c41154dda1a222cab6cc7e94a325d1e65b81998306ff48766cde7f41a63"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b74ce0496d081d448ec321bd25789c5417a9a105104ccbe4cbc98b0a2686c094"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b994d8b2b6493b16adb403a54f455376383a0f368f9aa08f8906e365782aa2b3"
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

    system "make", "install-whois", "prefix=#{prefix}", have_iconv
  end

  test do
    system bin/"whois", "brew.sh"
  end
end
