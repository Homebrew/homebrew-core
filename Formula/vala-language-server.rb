class ValaLanguageServer < Formula
  desc "Code Intelligence for Vala & Genie"
  homepage "https://github.com/Prince781/vala-language-server"
  url "https://github.com/Prince781/vala-language-server/archive/3e01b8383b3db3c39af276528663d6084c671455.tar.gz"
  version "0.48.3"
  sha256 "6f3b34bcb4e049c299ae3d5433153e4b685b0bace0ea8d761ffea266714ce841"
  license "LGPL-2.1-only"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_big_sur: "8dd0c7a04c35f113e4790087e83862b0678a3378471710cbab086785443e9a1e"
    sha256 cellar: :any, big_sur:       "522ff0afde99dc62e32af3df6d40138c4d115591a7d2c9ddf99a7ffb5c2354d8"
    sha256 cellar: :any, catalina:      "fc5ee5ec8ca3e5d41bc7cb5edd7a85540f5bce64d8d625548d706d884c28f83a"
    sha256 cellar: :any, mojave:        "13333288fba772232a82c3b16c10df48a6d41d4345897cbcba5e21fc0b15a2b4"
    sha256               x86_64_linux:  "abc6b06e996a54dd2c3c2e8567637cda104b0e4a975c9e3143519095429ab758"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "json-glib"
  depends_on "jsonrpc-glib"
  depends_on "libgee"
  depends_on "vala"

  def install
    system "meson", "-Dplugins=false", "build", *std_meson_args
    system "ninja", "-C", "build"
    system "ninja", "-C", "build", "install"
  end

  test do
    length = (151 + testpath.to_s.length)
    input =
      "Content-Length: #{length}\r\n" \
      "\r\n" \
      "{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"initialize\",\"params\":{\"" \
      "processId\":88075,\"rootPath\":\"#{testpath}\",\"capabilities\":{},\"trace\":\"ver" \
      "bose\",\"workspaceFolders\":null}}\r\n"
    output = pipe_output("#{bin}/vala-language-server", input, 0)
    assert_match(/^Content-Length: \d+/i, output)
  end
end
