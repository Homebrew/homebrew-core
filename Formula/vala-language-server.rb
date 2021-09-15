class ValaLanguageServer < Formula
  desc "Code Intelligence for Vala & Genie"
  homepage "https://github.com/Prince781/vala-language-server"
  url "https://github.com/Prince781/vala-language-server/archive/3e01b8383b3db3c39af276528663d6084c671455.tar.gz"
  version "0.48.3"
  sha256 "6f3b34bcb4e049c299ae3d5433153e4b685b0bace0ea8d761ffea266714ce841"
  license "LGPL-2.1-only"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "66e6aeafb3cebc38b59abc884dc2b5f8a477f7be38f5af65da07221810c2344b"
    sha256 cellar: :any, big_sur:       "19023fd359d99b7d63e5ca8f1ace69973f1fa9b20478cb17fa83d405a5b265b2"
    sha256 cellar: :any, catalina:      "c663948f5cef1359e3eb4b72ff1e27d756ebada28a224f7927a9564e681180b3"
    sha256 cellar: :any, mojave:        "e68b665fffd86e8b10dfa803cf1ffa2ac8cb0a39ecdda1bacf15e48fc8c6be26"
    sha256               x86_64_linux:  "4fc64f3172ccdd4c82d3ef5b7f3bc02c8780e40d3febb1950da2e1dcc9fc9023"
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
