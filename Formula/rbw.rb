class Rbw < Formula
  desc "Unofficial command-line client for Bitwarden"
  homepage "https://github.com/doy/rbw"
  url "https://github.com/doy/rbw/archive/0.5.2.tar.gz"
  sha256 "5ab3c569ea55eeee6e70130c3d1a3399ac0529b666e2ba12264c1a7b0b5dbc3c"
  license "MIT"

  depends_on "rust" => :build
  depends_on "openssl@1.1"
  depends_on "pinentry"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/rbw", "--version"
  end
end
