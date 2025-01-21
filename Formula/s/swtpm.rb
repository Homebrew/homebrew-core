class Swtpm < Formula
  desc "Software TPM Emulator based on libtpms"
  homepage "https://github.com/stefanberger/swtpm"
  url "https://github.com/stefanberger/swtpm/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "9f10ae0d3123ab05c3808f8c8d39f633cf1a0cf142d6ac9b87b8364a682ac842"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_sequoia: "4a2c3949e70a95b58041d26f22406573e7f388e66ee586f6ecceb152a7e7bbad"
    sha256 arm64_sonoma:  "ee23c88ac66faf5af97af08bb8ced8aee8df9303816734f192333e5e283107d4"
    sha256 arm64_ventura: "7d256e20aa50d3cf67738640fe8f5eb621eebc6227b4276ba29de9a4101e710a"
    sha256 sonoma:        "b8c0f97829f741d2617009b6a384f8a7a78d7935563a414ba3ebed9e1ec9ad06"
    sha256 ventura:       "28156039325983eb3a99891663edc2f31f728de2f0a1609fe7ddf6d89206ceda"
    sha256 x86_64_linux:  "80ea36298803fec03cb1f12daf266f913094ff6a0302ee41395f469d1f321ca7"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gawk" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "socat" => :build
  depends_on "glib"
  depends_on "gmp"
  depends_on "gnutls"
  depends_on "json-glib"
  depends_on "libtasn1"
  depends_on "libtpms"
  depends_on "openssl@3"

  uses_from_macos "expect"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "libseccomp"
    depends_on "net-tools"
  end

  def install
    system "./autogen.sh", "--with-openssl", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    port = free_port
    pid = spawn bin/"swtpm", "socket", "--ctrl", "type=tcp,port=#{port}"
    sleep 10
    system bin/"swtpm_ioctl", "--tcp", "127.0.0.1:#{port}", "-s"
  ensure
    Process.wait pid
  end
end
