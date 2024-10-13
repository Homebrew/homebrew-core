class Yash < Formula
  desc "Yet another shell: a POSIX-compliant command-line shell"
  homepage "https://magicant.github.io/yash/"
  url "https://github.com/magicant/yash/releases/download/2.57/yash-2.57.tar.xz"
  sha256 "f5ff3334dcfa0fdde3882f5df002623f46a0a4f2b2335e7d91715520d8fb1dab"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_sequoia:  "db3ca81751898d9821d110a1d3e0069c750a3da74472a1cdfcbba2e3abc56090"
    sha256 arm64_sonoma:   "e608448371edb07002359684015ab5118824c29ec7c70168af84a2886b17ddb2"
    sha256 arm64_ventura:  "936e90709d1a3ee4ef8398a82ddfbb4bcf1997b30e64d186eced9d70121e62ab"
    sha256 arm64_monterey: "2982cbe9943e5b225cb1eb5af875ab06acd63980c3301a32d73e02f42f6d97ad"
    sha256 sonoma:         "76b9fff147765d87cdf0d89ea72c99cb35889a3c5fdc87bb9646404deb0872a2"
    sha256 ventura:        "58ea4fe91d0154ed774b0d1a8b55ea7edbf40b9702a210a53b6356105ec8f3ca"
    sha256 monterey:       "ef4a1ec88d9193984ce980a171266475fbd137bdf907159d43a327079869f743"
    sha256 x86_64_linux:   "75d73cb78840a2efec9a399da2ed5569ad01d0b731bf359339f3416bb90bd096"
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
