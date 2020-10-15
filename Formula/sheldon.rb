class Sheldon < Formula
  desc "Fast, configurable, shell plugin manager"
  homepage "https://rossmacarthur.github.io/sheldon"
  url "https://github.com/rossmacarthur/sheldon/archive/0.5.4.tar.gz"
  sha256 "2707f05f59ce3df7e572f8a098d6f0d675b0b351695d04ba8d159d5a7eee8562"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rossmacarthur/sheldon.git"

  bottle do
    cellar :any
    sha256 "c0b02a54e4d4aa0fc5d444d25dc4931284e195805f589072a7c67527d58f3553" => :catalina
    sha256 "5b87b182244565b087e5d781f9adc3955002a4306b4e87c57a202c0d75a5ca3a" => :mojave
    sha256 "3f1fdfdfac34a711fd99a9db7d6bec8375bdc7633b16433551ab23834ce6c5ae" => :high_sierra
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
