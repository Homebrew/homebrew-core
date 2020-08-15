class Sheldon < Formula
  desc "Fast, configurable, shell plugin manager"
  homepage "https://rossmacarthur.github.io/sheldon"
  url "https://github.com/rossmacarthur/sheldon/archive/0.5.4.tar.gz"
  sha256 "2707f05f59ce3df7e572f8a098d6f0d675b0b351695d04ba8d159d5a7eee8562"
  license ["Apache-2.0", "MIT"]
  head "https://github.com/rossmacarthur/sheldon.git"

  bottle do
    cellar :any
    sha256 "d1a4347ae1da63cdd709d88b458cb33ef37860f9aba634c574d66a12d56cfa77" => :catalina
    sha256 "a92939b2ee92320e8905ec7c71a68e109c1e46424dd7d7620645e4ea7037557d" => :mojave
    sha256 "0890f9bcbce9e3ae8c657ea9b811404e34bc20e6416ab64d626c1f3baf97d2ac" => :high_sierra
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    touch testpath/"plugins.toml"
    system "#{bin}/sheldon", "--home", testpath, "--root", testpath, "lock"
    assert_predicate testpath/"plugins.lock", :exist?
  end
end
