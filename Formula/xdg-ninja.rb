class XdgNinja < Formula
  desc "Check your $HOME for unwanted files and directories"
  homepage "https://github.com/b3nj5m1n/xdg-ninja"
  url "https://github.com/b3nj5m1n/xdg-ninja/archive/refs/tags/v0.2.0.1.tar.gz"
  sha256 "f4f9ab4500e7cf865ff8b68c343537e27b9ff1e6068cb1387e516e608f77cec8"
  license "MIT"
  head "https://github.com/b3nj5m1n/xdg-ninja.git", branch: "main"

  depends_on "glow"
  depends_on "jq"

  def install
    prefix.install "programs/"
    prefix.install "xdg-ninja.sh" => "xdg-ninja"
    bin.install_symlink prefix/"xdg-ninja"
  end

  test do
    system bin/"xdg-ninja"
  end
end
