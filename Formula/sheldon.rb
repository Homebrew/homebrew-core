class Sheldon < Formula
  desc "Fast, configurable, shell plugin manager"
  homepage "https://rossmacarthur.github.io/sheldon"
  url "https://github.com/rossmacarthur/sheldon/archive/0.6.3.tar.gz"
  sha256 "050ca9fccde1e685b4e74ca25aa33119b8ca4acd9e5b5e6deb58435a9814e000"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rossmacarthur/sheldon.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "4abfeddfd1546805770130b4eba4480ca749bf8fcdf7b6692c5c2ef4c2ec7c7c"
    sha256 cellar: :any, big_sur:       "c7ef56ae60df786192350f36dcad87d3c2c9c446d1c490aa1f6e5e3d6924dd3e"
    sha256 cellar: :any, catalina:      "87b5befd0a415b0f98f3c8fa87ace35e3c6e08bda40d7851609f8e89e2ec9e15"
    sha256 cellar: :any, mojave:        "1c79640519f0f272a3924534b6ad988bea566c4cca4941ed865c5466324108b6"
  end

  depends_on "rust" => :build
  depends_on "curl"
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
