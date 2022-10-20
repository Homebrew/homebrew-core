class XdgNinja < Formula
  desc "Check your $HOME for unwanted files and directories"
  homepage "https://github.com/b3nj5m1n/xdg-ninja"
  url "https://github.com/b3nj5m1n/xdg-ninja/archive/refs/tags/v0.2.0.1.tar.gz"
  sha256 "f4f9ab4500e7cf865ff8b68c343537e27b9ff1e6068cb1387e516e608f77cec8"
  license "MIT"
  head "https://github.com/b3nj5m1n/xdg-ninja.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "143b6fed536da8327d4cb7068108e6cd787eee32d9e297f8c435f781044fb755"
  end

  depends_on "glow"
  depends_on "jq"

  on_macos do
    depends_on "coreutils"
  end

  def install
    pkgshare.install "programs/"
    pkgshare.install "xdg-ninja.sh" => "xdg-ninja"
    bin.install_symlink pkgshare/"xdg-ninja"
  end

  test do
    system bin/"xdg-ninja"
  end
end
