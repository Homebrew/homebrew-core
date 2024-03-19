class Wrk < Formula
  desc "HTTP benchmarking tool"
  homepage "https://github.com/wg/wrk"
  url "https://github.com/wg/wrk/archive/refs/tags/4.2.0.tar.gz"
  sha256 "e255f696bff6e329f5d19091da6b06164b8d59d62cb9e673625bdcd27fe7bdad"
  # License is modified Apache 2.0 with addition to Section 4 Redistribution:
  #
  # (e) If the Derivative Work includes substantial changes to features
  #     or functionality of the Work, then you must remove the name of
  #     the Work, and any derivation thereof, from all copies that you
  #     distribute, whether in Source or Object form, except as required
  #     in copyright, patent, trademark, and attribution notices.
  license :cannot_represent
  revision 1
  head "https://github.com/wg/wrk.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "89a17214695f28852b9be47589b1f8788b7209201c163b2bf39b608c1ba2bacd"
    sha256 cellar: :any,                 arm64_ventura:  "f1838e262aaea9a48cd54b0e33c25e39131a9732d5e9b9748498ef37cf468699"
    sha256 cellar: :any,                 arm64_monterey: "dff2f475aaebf54bf90ca442ed041fb857b43249e9c8c7f4503018bb3970a4e3"
    sha256 cellar: :any,                 arm64_big_sur:  "8a60990dd837067cc883e28fa18500ed86125cf054f2d4030098423b879b97f6"
    sha256 cellar: :any,                 sonoma:         "11ddc1b8dfc48bd2c8bb3b2b96f4b01b5356f5b8d0702d7ee287bf56a96b3b55"
    sha256 cellar: :any,                 ventura:        "cd319593d2f5ad2d1335cac14ebbf192af7502a63e83d4b8d1cb6e80fede99e4"
    sha256 cellar: :any,                 monterey:       "86b756396151c118e4a2e419b692923a6c8d71a02f355f5c1390fe11659125ab"
    sha256 cellar: :any,                 big_sur:        "fcb1b19c7ec424642d0dc7cf0a9a1dde8872a64a4e91fdf07a16f0b64ba10e4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4295514a73470421b9cadc29d0f2873de383cc7b9d31523028d2310ef6e437b"
  end

  depends_on "luajit"
  depends_on "openssl@3"

  conflicts_with "wrk-trello", because: "both install `wrk` binaries"

  def install
    ENV.deparallelize
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version.to_s if OS.mac?
    ENV.append_to_cflags "-I#{Formula["luajit"].opt_include}/luajit-2.1"
    args = %W[
      WITH_LUAJIT=#{Formula["luajit"].opt_prefix}
      WITH_OPENSSL=#{Formula["openssl@3"].opt_prefix}
    ]
    args << "VER=#{version}" unless build.head?
    system "make", *args
    bin.install "wrk"
  end

  test do
    system bin/"wrk", "-c", "1", "-t", "1", "-d", "1", "https://example.com/"
  end
end
