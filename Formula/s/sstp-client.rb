class SstpClient < Formula
  desc "SSTP (Microsoft's Remote Access Solution for PPP over SSL) client"
  homepage "https://gitlab.com/sstp-project/sstp-client"
  url "https://gitlab.com/sstp-project/sstp-client/-/releases/1.0.20/downloads/dist-gzip/sstp-client-1.0.20.tar.gz"
  sha256 "6c84b6cdcc21ebea6daeb8c5356dcdfd8681f4981a734f8485ed0b31fc30aadd"
  license "GPL-2.0-or-later"
  revision 1
  version_scheme 1
  head "https://gitlab.com/sstp-project/sstp-client.git", branch: "master"

  bottle do
    sha256 arm64_golden_gate: "4eee3d36b131fe0e40ea50de49deab2d679afb6b10a920dc853a3863f432996f"
    sha256 arm64_tahoe:       "6e3051de8c12c66ef804f62ed0a41bd3ed39238b26583079fdffd0801667dd4f"
    sha256 arm64_sequoia:     "a2888685823ef9d57a79d9bd9c7433cad2c4c4d7386117245ce1149bcfef5b9f"
    sha256 arm64_linux:       "5622bc3d6c01ca002f6cafb7896b7f6bea34ac2d7b475c4482ce2495bee3a629"
    sha256 x86_64_linux:      "e1efeefe8a8a227f5493cdd097e34fa1f946d8acb0569632718150b96a7a05f3"
  end

  depends_on "pkgconf" => :build
  depends_on "libevent"
  depends_on "openssl@4"

  def install
    system "./configure", "--disable-silent-rules",
                          "--disable-ppp-plugin",
                          "--with-runtime-dir=#{var}/run/sstpc",
                          *std_configure_args
    system "make", "install"

    # Create a directory needed by sstpc for privilege separation
    (var/"run/sstpc").mkpath
  end

  def caveats
    <<~EOS
      sstpc reads PPP configuration options from /etc/ppp/options. If this file
      does not exist yet, type the following command to create it:

      sudo touch /etc/ppp/options
    EOS
  end

  test do
    system sbin/"sstpc", "--version"
  end
end
