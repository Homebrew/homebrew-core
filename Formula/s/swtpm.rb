class Swtpm < Formula
  desc "Software TPM Emulator based on libtpms"
  homepage "https://github.com/stefanberger/swtpm"
  url "https://github.com/stefanberger/swtpm/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "b281b4e8c39f68e1928675f788abc70072e4081152e129144359a8c5c304c06b"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_sonoma:   "baaeb465870ec3f198b2394bd25e6ad4acb5148ace77f39ddc28be7255023a46"
    sha256 arm64_ventura:  "f164ab58f93bea52dff81841cdaf797f4ff56700fa08cf6a0dd9bf837a100a61"
    sha256 arm64_monterey: "a3258beeb9825bbea0695d70bdba8f8e06e9329c3cc10f201de530fda5afa7c6"
    sha256 sonoma:         "626d623849eddf4e791c756eea48faeaa2dff479814894d96585a4b277d3da1d"
    sha256 ventura:        "5b572f4e5a93feace4af6267274f78c12a5e505f28a9bde67d204c3b79d54d2b"
    sha256 monterey:       "ca8ef467bab1caed06b0c52ac6af4862413dfa4ffb28384780b33830678940d3"
    sha256 x86_64_linux:   "2fc4736436af46f1f2972da78c41f636c71c8d95d9a02ab90090a89620e489d7"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gawk" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "socat" => :build
  depends_on "gnutls"
  depends_on "json-glib"
  depends_on "libtasn1"
  depends_on "libtpms"
  depends_on "openssl@3"

  uses_from_macos "expect"

  on_linux do
    depends_on "libseccomp"
    depends_on "net-tools"
  end

  def install
    system "./autogen.sh", *std_configure_args, "--with-openssl"
    system "make"
    system "make", "install"
  end

  test do
    port = free_port
    pid = fork do
      system bin/"swtpm", "socket", "--ctrl", "type=tcp,port=#{port}"
    end
    sleep 2
    system bin/"swtpm_ioctl", "--tcp", "127.0.0.1:#{port}", "-s"
  ensure
    Process.wait pid
  end
end
