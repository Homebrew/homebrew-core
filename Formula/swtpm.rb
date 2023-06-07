class Swtpm < Formula
  desc "Software TPM Emulator based on libtpms"
  homepage "https://github.com/stefanberger/swtpm"
  url "https://github.com/stefanberger/swtpm/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "ad433f9272fb794aafd550914d24cc0ca33d4652cfd087fa41b911fa9e54be3d"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_ventura:  "bc5816c26309d1a2073ccf1ce2cae8d36f1641bc63b2c487c24d013e7d200f41"
    sha256 arm64_monterey: "8d4ab5a4240d3943779847d5da89be5cf7ce402faa4155dcf69bf4f6e0ffc763"
    sha256 arm64_big_sur:  "2fffae664bf170883630d4e9ac91de73aec5900f2ad97175520adea11f616785"
    sha256 ventura:        "b000c7663637a584cd8f03b8c32ef4b2bd36aeb4b185b6333fff4a14f5f3e8af"
    sha256 monterey:       "a6a18a0f7778bd69375560fd80a9c869493f305a6d0651b8550f10a625ff757b"
    sha256 big_sur:        "412a9cde094309914c23f0292db34ab60e87a377206919fd9e2f665c36370b59"
    sha256 catalina:       "5128a71f8187c9e7eab84dce6cc8eec133645aa09842e0921b102985b62f9ee2"
    sha256 x86_64_linux:   "2670e800383b9d54b29e4041584a2ab94d169598451ed09822b08a4e492aefb7"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gawk" => :build
  depends_on "libtool" => :build
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
    ENV.append "LDFLAGS", "-L#{Formula["openssl@3"].opt_lib}" if OS.linux?

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
