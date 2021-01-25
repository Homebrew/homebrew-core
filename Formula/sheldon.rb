class Sheldon < Formula
  desc "Fast, configurable, shell plugin manager"
  homepage "https://rossmacarthur.github.io/sheldon"
  url "https://github.com/rossmacarthur/sheldon/archive/0.6.0.tar.gz"
  sha256 "5c04abd956634725e23a3a782fe0fb40a9fe1323ed07fcf8ff2a30ce59b83b59"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rossmacarthur/sheldon.git"

  bottle do
    cellar :any
    sha256 "1acd1c15437fbe6c58223e5dbd14c14fdb79e5b5cb5ee6f5505ab1fc3fa65432" => :big_sur
    sha256 "a0968805397cf22b45b76d7fbe74764ad03b4dd4a45b8417b69fbfc01fa95d8a" => :arm64_big_sur
    sha256 "7bbb0e9ca7d115d7ed4c310248c3937e7117feab47ba13683a80f675d76b4c44" => :catalina
    sha256 "72906d43188f39876956cea5803662f6eba42c59b285ae48e46853e671f9312f" => :mojave
    sha256 "ab46bcf3bdea25e2f39aa079044d9bf3ccd691697296e6747f9f63fe09c316b4" => :high_sierra
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    touch testpath/"plugins.toml"
    system "#{bin}/sheldon", "--home", testpath, "--config-dir", testpath, "--data-dir", testpath, "lock"
    assert_predicate testpath/"plugins.lock", :exist?
  end
end
