class ValaLanguageServer < Formula
  desc "Code Intelligence for Vala & Genie"
  homepage "https://github.com/vala-lang/vala-language-server"
  url "https://github.com/vala-lang/vala-language-server/releases/download/0.48.7/vala-language-server-0.48.7.tar.xz"
  sha256 "a93e09497738144792466d0c5ccb1347583d84a9987b65b08f6aa5d5a1e3f431"
  license "LGPL-2.1-only"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any, arm64_tahoe:    "6de961a16d8c01a87334d3e5f8952bccde9d82e321719c8b7606a173b6a4f79b"
    sha256 cellar: :any, arm64_sequoia:  "7b298f02d9378880231ad35d238897b5fa76e7a0c92efc802676f114fe20ab9f"
    sha256 cellar: :any, arm64_sonoma:   "ac975caa3ddb69b060ade26f3fd96eb26d1ea002cb52742c0418a4edc23058ff"
    sha256 cellar: :any, arm64_ventura:  "8bceda4daa8845f577ab8133fff13b22ff342e9d9bc567a3b0e9c97eb6de8ab8"
    sha256 cellar: :any, arm64_monterey: "51eb75d062bfb8901eaeff0ca491584cfbc62bb266861ab760d9fd1c34aada5d"
    sha256 cellar: :any, arm64_big_sur:  "865dc144b42045cf9243ef56f7153dc341d6cb160b957c11f900844c27e4a2c5"
    sha256 cellar: :any, sonoma:         "2142ed177e269f7b29398f13dab2e234cd788becf8a4220c1a1c7f0b9b24925d"
    sha256 cellar: :any, ventura:        "5c3225a7fd5a42ae0b78713fe57ed1840ec4b090393e8e1cf53c1d250a392641"
    sha256 cellar: :any, monterey:       "0b7304461e6e427f1ed2ebad4dcb6d66589c0bb5f77c6cf921207359461e5e46"
    sha256 cellar: :any, big_sur:        "237b5e936501fb0d96ca3304947f4224113d39bb4a218a1b25d0702959a1fe81"
    sha256               arm64_linux:    "f7bde32833468a8a783f9992ed2aad1dda845285a650bb7f1c69e8ad2fc24b8e"
    sha256               x86_64_linux:   "063a6451f6da46ce3112e2de698c723b69867fb4890a97b5ae78b16dc85ef23d"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "glib"
  depends_on "json-glib"
  depends_on "jsonrpc-glib"
  depends_on "libgee"
  depends_on "vala"

  on_macos do
    depends_on "gettext"
  end

  def install
    # Workaround to build with newer clang
    # Upstream bug report, https://github.com/vala-lang/vala-language-server/issues/310
    ENV.append_to_cflags "-Wno-incompatible-function-pointer-types" if DevelopmentTools.clang_build_version >= 1500

    system "meson", "setup", "build", "-Dplugins=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    length = (testpath.to_s.length + 151)
    input =
      "Content-Length: #{length}\r\n" \
      "\r\n" \
      "{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"initialize\",\"params\":{\"" \
      "processId\":88075,\"rootPath\":\"#{testpath}\",\"capabilities\":{},\"trace\":\"ver" \
      "bose\",\"workspaceFolders\":null}}\r\n"

    output = pipe_output(bin/"vala-language-server", input, 0)
    assert_match(/^Content-Length: \d+/i, output)
  end
end
