class ValaLanguageServer < Formula
  desc "Code Intelligence for Vala & Genie"
  homepage "https://github.com/Prince781/vala-language-server"
  url "https://github.com/Prince781/vala-language-server/releases/download/0.48.4/vala-language-server-0.48.4.tar.xz"
  sha256 "0fd65b641a4bd6e0385502f0536f803bf542fd8bae6a2adb04e2e299ccca4551"
  license "LGPL-2.1-only"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_monterey: "aafa52097b542644b26934efca5da76c93acf015870c0f1cddb6977d76884afd"
    sha256 cellar: :any, arm64_big_sur:  "d0c7d068b5bec716e17c39591384d60a08bdd82b655bca866840878c67f9358c"
    sha256 cellar: :any, monterey:       "fa3273c84ac17406a6bc1601613565036766021e734ce3e04b0a4b1be15070e6"
    sha256 cellar: :any, big_sur:        "d296ad4b78e5929b7d40b4396935c1f73421306065a3d41d223c2206f5adafe2"
    sha256 cellar: :any, catalina:       "080acb613db0332326799ef24609f56e443e087f192709ea6cd32827d35dc855"
    sha256               x86_64_linux:   "078aeddd7a515c66e5bc58dc569e77ec0f578647c3f4aa154f34f8193e5b7f6f"
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
