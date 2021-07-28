class Trunk < Formula
  desc "Build, bundle & ship your Rust WASM application to the web"
  homepage "https://github.com/thedodd/trunk"
  url "https://github.com/thedodd/trunk/archive/v0.12.1.tar.gz"
  sha256 "6f4e74f83f1ab7a224f1ab82483cde90be7057e6b6f6f26754e8aff8f3e1ba98"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/thedodd/trunk.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "879dff359548f9f1a2221c6597015de932a611c4427fbd7afca7e641bfe23ea1"
    sha256 cellar: :any_skip_relocation, big_sur:       "22dc948e539e051d408d101730b71217918075c0b21e9d20619df6b5cdf311f1"
    sha256 cellar: :any_skip_relocation, catalina:      "ecbc3d073742cd8b777a65ef58e025307abae7e4c5e6d88074e4aea4d324d195"
    sha256 cellar: :any_skip_relocation, mojave:        "36a8c526efa9b9b7221b3a6c8210a2c9adff899c7e25d7aa3a3393d49093474a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e84f59b2b2391f11e8b95d4d0bfa0da9ed4a856b8908933ba0b2176c71e6967"
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
