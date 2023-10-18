class Terminalimageviewer < Formula
  desc "Display images in a terminal using block graphic characters"
  homepage "https://github.com/stefanhaustein/TerminalImageViewer"
  url "https://github.com/stefanhaustein/TerminalImageViewer/archive/refs/tags/v.1.2.tar.gz"
  sha256 "6807ab4986b3893e97e8ee0eb59f02d93ff74a3994bf524d7747ac80b827184b"
  license "Apache-2.0"
  head "https://github.com/stefanhaustein/TerminalImageViewer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9eaaf65db7366655dc972e5a74fd9e83a29a43ae6d2abe999d49bbeb2cc4a106"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "14e11f4ffaf73746aeeb970788d23ca773ba6fc7e6555ba0a26630c57107f473"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b9d18a0d8af8ab824b41235b49a7f161881df7bfcbcdcb6689be83aaad0a4ae"
    sha256 cellar: :any_skip_relocation, sonoma:         "a17756964ac946c3559f040d0c59f3d5ed64306e203724d44e297a4ca5cd21b9"
    sha256 cellar: :any_skip_relocation, ventura:        "e3fb80f6ffedd3ebbf6319c6348d74af0f399b6b16c77605a95ef143f626c620"
    sha256 cellar: :any_skip_relocation, monterey:       "04257fc4451f77b686e47aba01e76e691ac1dcc375a8dfa499434a3113e30167"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6307c82112b211b7a05514a638c99191d3c31f92d6b196a4b1a987a6d4bce368"
  end

  depends_on "imagemagick"
  depends_on macos: :catalina

  fails_with gcc: "5"

  def install
    cd "src" do
      system "make"
      bin.install "tiv"
    end
  end

  test do
    system bin/"tiv", test_fixtures("test.png")
  end
end
