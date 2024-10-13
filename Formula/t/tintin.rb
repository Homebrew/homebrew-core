class Tintin < Formula
  desc "MUD client"
  homepage "https://tintin.mudhalla.net/"
  url "https://github.com/scandum/tintin/releases/download/2.02.41/tintin-2.02.41.tar.gz"
  sha256 "b86b4af5a57b986d4ef5db41e64d38e027cf85004749479c9424f18df7642a49"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "dac578a0c6c96217dd1dcd1d0c4be5716ca9876798fbc990bf00ef6a0c34f643"
    sha256 cellar: :any,                 arm64_sonoma:   "64acefaf2f1dae303c72b1c27e507a16198b2dd38fe051aa98bfcc96beb413e5"
    sha256 cellar: :any,                 arm64_ventura:  "93a881b57f3f805973ddf227470ed4b3f6d71ab49f4dfab877d8997a1f390a89"
    sha256 cellar: :any,                 arm64_monterey: "807575c3e4722326d51bb213a11d9bb62d22e30c27494e0e3b09eef34d60b1dd"
    sha256 cellar: :any,                 sonoma:         "bf152b74032e58f7938f17084c1b69c0c691e89a448d355cd58d6cfb73185da8"
    sha256 cellar: :any,                 ventura:        "65e603e6184e01f46203b2e461ac88141bcb0d6759c8510d892327d7e32eab8f"
    sha256 cellar: :any,                 monterey:       "78e273335ab2a23248743fce208fa0089009d3df2d5bfaea0c53fc3dc4a8feee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1d3b0b57e1fb479e274dbb7a5cb50c48ba7e1fed97f2896e2c010125790abb2"
  end

  depends_on "gnutls"
  depends_on "pcre" # PCRE2 issue: https://github.com/scandum/tintin/issues/163

  uses_from_macos "zlib"

  def install
    # find Homebrew's libpcre
    ENV.append "LDFLAGS", "-L#{HOMEBREW_PREFIX}/lib"

    cd "src" do
      system "./configure", "--prefix=#{prefix}"
      system "make", "CFLAGS=#{ENV.cflags}",
                     "INCS=#{ENV.cppflags}",
                     "LDFLAGS=#{ENV.ldflags}",
                     "install"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tt++ -V", 1)
  end
end
