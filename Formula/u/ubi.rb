class Ubi < Formula
  desc "Universal Binary Installer"
  homepage "https://github.com/houseabsolute/ubi"
  url "https://github.com/houseabsolute/ubi/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "e9f6a2d688476c0ebb89164c0e54fdbd97f4c31fced855ef9d3bb37bfdc4852c"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/houseabsolute/ubi.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "143dd359448347b21815b5d25d6cdae257a5d864787da673fe0ab41c52a1dce3"
    sha256 cellar: :any,                 arm64_sonoma:  "3a8f1a6cc60b635fe3b90d29a416eafc9821175a7425b61b42e1d3bb6a90ebb0"
    sha256 cellar: :any,                 arm64_ventura: "621c75822f06a98d4815fd8bf9d1f050adb2a49db8df9a30dc0edea0decb6ff0"
    sha256 cellar: :any,                 sonoma:        "13267cc89276298338ad24b8576db841675f576ab72c2edaba189990999d8f03"
    sha256 cellar: :any,                 ventura:       "9e6f36d86708cb9ad30305a66dbcb86bada5c63e869b5dd8aba43f5fcb3605f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c10ebde4475f1673b9ebd3899219cd5f00d90fb596a282f160eeb7408712b648"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "262c1dcf67a9969c5e359e705faac2bd2221eb032847b5bc78fb988d2cb0d445"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "xz" # required for lzma support

  uses_from_macos "bzip2"

  def install
    system "cargo", "install", *std_cargo_args(path: "ubi-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ubi --version")

    system bin/"ubi", "--project", "houseabsolute/precious"
    system testpath/"bin/precious", "--version"
  end
end
