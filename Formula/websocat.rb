class Websocat < Formula
  desc "Command-line client for WebSockets"
  homepage "https://github.com/vi/websocat"
  url "https://github.com/vi/websocat/archive/v1.5.0.tar.gz"
  sha256 "3ffdb25e937095d95b564eafd805cb7ca141570f95c1296b6dd336d4d016445f"

  bottle do
    cellar :any_skip_relocation
    sha256 "2743255efe843f83405fa0920983ae1b8968d82af9106850592719101676fa09" => :mojave
    sha256 "ebb4062bf94cb09166f903355f1be7f64b4b83d6f13bd3a4500677874f64ccbe" => :high_sierra
    sha256 "187f0c39b94240605d65257815b59020a00e9ca7e7bb8e9e3fb726918429aa41" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix,
                               "--path", ".",
                               "--features", "ssl"
  end

  test do
    system "#{bin}/websocat", "-t", "literal:qwe", "assert:qwe"
  end
end
