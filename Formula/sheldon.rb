class Sheldon < Formula
  desc "Fast, configurable, shell plugin manager"
  homepage "https://rossmacarthur.github.io/sheldon"
  url "https://github.com/rossmacarthur/sheldon/archive/0.6.2.tar.gz"
  sha256 "454da0a9ea6305a81aa340a60870a2fa529c7f25cd87c35af1ba6907514a6e4d"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rossmacarthur/sheldon.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "f18834a296da8975d65628f31dfacaf661c3797dd883d971616ed3083391af4a"
    sha256 cellar: :any, big_sur:       "eed38c13b48c789d3b80314c81a79b454937b4898e4c8ea01aca8e6033d4eccf"
    sha256 cellar: :any, catalina:      "4969320a627be9cc5795fe54ae4b5064685cc0d28a73fdfb743e87d2a34e4a6c"
    sha256 cellar: :any, mojave:        "09af95d2e7ed90c97b72cf23b25b5991749f2224a8316bd2ac188d766ccd29a2"
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
