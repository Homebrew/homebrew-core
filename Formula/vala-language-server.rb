class ValaLanguageServer < Formula
  desc "Code Intelligence for Vala & Genie"
  homepage "https://github.com/vala-lang/vala-language-server"
  url "https://github.com/vala-lang/vala-language-server/releases/download/0.48.5/vala-language-server-0.48.5.tar.xz"
  sha256 "698a0f26b61a882517f31039e7dc8efdda1384de0687b1ab78f2a768c305b17e"
  license "LGPL-2.1-only"

  bottle do
    sha256 cellar: :any, arm64_monterey: "e52da2c7a6d04e21500d5c94b50e960071a30e4c8e5ccc3eb35e62950d5afe63"
    sha256 cellar: :any, arm64_big_sur:  "696c0222b7254ba09819682b05659522794e27281a24a6d1cd0d7edb1034b881"
    sha256 cellar: :any, monterey:       "9d60b232a351cd76708ddcd8253d51dcf78d821d61f8a152d781478d6d2c7a13"
    sha256 cellar: :any, big_sur:        "f3f713cd02ef48c53f475e660e4719d5ade539f8739a2ac30b16c39a9b66a41b"
    sha256 cellar: :any, catalina:       "e1adfcc2dab05e3633d76a8397cffae5e9e37530d28f90468c593bcbb3cef7ab"
    sha256               x86_64_linux:   "505cda33ad604a86e51d83bd97c9940978439de9c6b14a3260f282d41bbb698e"
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
