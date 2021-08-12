class Trunk < Formula
  desc "Build, bundle & ship your Rust WASM application to the web"
  homepage "https://github.com/thedodd/trunk"
  url "https://github.com/thedodd/trunk/archive/v0.13.1.tar.gz"
  sha256 "c9c01c9d2aff59a8fac11a4eee4879a17ace0d2262532a391b7f5e92623caae6"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/thedodd/trunk.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d07b020b907c09197db7bc81a972929069defc4a575a670de6c8ecee3ec528f7"
    sha256 cellar: :any_skip_relocation, big_sur:       "9c6aa5119281af93f3c2674d02e71dca7c35e5b4da61a5c7b134e38d9b8b5b5b"
    sha256 cellar: :any_skip_relocation, catalina:      "cc663c7e6a314fe6d020288e8422e513c0fb60a6895ecce17b9c5b330d6f8eee"
    sha256 cellar: :any_skip_relocation, mojave:        "358eec5df425f78dc13e7c893942074ec046803a99bc31bc022cca38126d45a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f87770488cbac5acc72bcd4cbb4718fcf7190357fe614c2f5e03e025a09c12c1"
  end

  depends_on "rust" => :build

  uses_from_macos "openssl@1.1"
  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "ConfigOpts {\n", shell_output("#{bin}/trunk config show")
  end
end
