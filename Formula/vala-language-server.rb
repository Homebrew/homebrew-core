class ValaLanguageServer < Formula
  desc "Code Intelligence for Vala & Genie"
  homepage "https://github.com/vala-lang/vala-language-server"
  url "https://github.com/vala-lang/vala-language-server/releases/download/0.48.4/vala-language-server-0.48.4.tar.xz"
  sha256 "0fd65b641a4bd6e0385502f0536f803bf542fd8bae6a2adb04e2e299ccca4551"
  license "LGPL-2.1-only"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_monterey: "a23bbac929f9a26ce34722df50036ba8bcedfd701b44c98aa2672ccdcb32c5eb"
    sha256 cellar: :any, arm64_big_sur:  "f1d742cc6026cedaec272a18d61ff0c1e5dbccc1c1e345e0baacfb4f3319963e"
    sha256 cellar: :any, monterey:       "40d80fa55a2f767a97e17e7b7b21e39557b44bfa34eddc131971e5f62c6a838b"
    sha256 cellar: :any, big_sur:        "7de4d55be1e5d00de01010688738af7ba5274788b9367b42197cea77972c26dd"
    sha256 cellar: :any, catalina:       "aba8a72cab7b03e5051e3a33e2c9288aaeedecfbb85b88055d51ffedf8ee85fc"
    sha256               x86_64_linux:   "6478587d4b72b39e375e691703681768c46b8d2685f9d4b7f7a49c101a607ee9"
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
