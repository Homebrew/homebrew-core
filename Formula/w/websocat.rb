class Websocat < Formula
  desc "Command-line client for WebSockets"
  homepage "https://github.com/vi/websocat"
  url "https://github.com/vi/websocat/archive/refs/tags/v1.14.1.tar.gz"
  sha256 "5c976c535800ca635b72839fe49d0fe4ad2479db8744c5a00f0cf911e4832e2d"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6f1d55c1251a7ba4f35cfba173b03597528e12299a05997e4b7b53fce1f554e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "266c6def79896bc1474ec11fe544e31465c4dc44fc1f4e6f0024e8487eb5a4d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "519e9b048400f4650931d4f95b98d526fbf809d49afcd341ff63e6b2919e8d0c"
    sha256 cellar: :any_skip_relocation, sonoma:        "8aa7862d2353ab1b8c3d3200d486419cf2f9b87f379e2872d3ea48acc3fead93"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38cb45e49cfd724483a5b95f86e3de3fc65d1238c9607269b53136867931a5a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33fe3fb016eec0925dfcd6cf0e8882abfa834bd247463d89ace9db6ef4d137f9"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", "--features", "ssl", *std_cargo_args
  end

  test do
    system bin/"websocat", "-t", "literal:qwe", "assert:qwe"
  end
end
