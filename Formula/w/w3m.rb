class W3m < Formula
  desc "Pager/text based browser"
  homepage "https://w3m.sourceforge.net/"
  license "w3m"
  head "https://github.com/tats/w3m.git", branch: "master"

  stable do
    url "https://deb.debian.org/debian/pool/main/w/w3m/w3m_0.5.3+git20230121.orig.tar.xz"
    sha256 "974d1095a47f1976150a792fe9c5a44cc821c02b6bdd714a37a098386250e03a"
    version "0.5.3-git20230121"

    # Fix for CVE-2023-4255
    patch do
      url "https://sources.debian.org/data/main/w/w3m/0.5.3%2Bgit20230121-2.1/debian/patches/0002-CVE-2023-4255.patch"
      sha256 "7a84744bae63f3e470b877038da5a221ed8289395d300a904ac5a8626b0a9cea"
    end
  end

  livecheck do
    url "https://deb.debian.org/debian/pool/main/w/w3m/"
    regex(/href=.*?w3m[._-]v?(\d+(?:\.\d+)+(?:\+git\d+)?)\.orig\.t/i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match.first.tr("+", "-") }
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "66b442a770ff9d6b7abb96a5994925af7a6ae07c68c4362d801e3d9b69f1fc6f"
    sha256 arm64_sequoia: "d43c6ea193e92ae3a7ff8c68d77dfa6b69b28695bf0ef4009c07a8b55049bbb0"
    sha256 arm64_sonoma:  "7ebcfdfd3b2424232e38d4bb2df40b78aa189a5f9f59d7d95479a5c9b5504962"
    sha256 arm64_ventura: "76450cc0ba39c902c03f3262950fc6fbd71ab37487d8b739d3c39294e08f269f"
    sha256 sonoma:        "b832f5eced22941c1c3f44520dd6bc6f656d861c27eb52a942b93723df23d0da"
    sha256 ventura:       "b0a1d6e3855af50f3d32878d2889fa99f281985bec224b18ce42e48d55df89a1"
    sha256 arm64_linux:   "bf66af8f63d1faba8adeccf8539174f8cf1e40834068a57745ef7f8916694079"
    sha256 x86_64_linux:  "08f462b37359e85d7d9628d5bfce123da1f7e28c1811157b3d485cb6424fff39"
  end

  depends_on "pkgconf" => :build
  depends_on "bdw-gc"
  depends_on "openssl@3"

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "./configure", "--disable-image",
                          "--with-ssl=#{Formula["openssl@3"].opt_prefix}",
                          *std_configure_args
    system "make", "install"
  end

  test do
    assert_match "DuckDuckGo", shell_output("#{bin}/w3m -dump https://duckduckgo.com")
  end
end
