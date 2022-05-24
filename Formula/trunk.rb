class Trunk < Formula
  desc "Build, bundle & ship your Rust WASM application to the web"
  homepage "https://github.com/thedodd/trunk"
  url "https://github.com/thedodd/trunk/archive/v0.15.0.tar.gz"
  sha256 "cb11302aa1d41ad6cd2ad7734a6717a4d4a947d59605e831adbf84df1940618e"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/thedodd/trunk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12825097ce0d6cfab52e75dfa4b87d53fcd2c6c73b1fd1f9dca460422a7720f0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5d9c22852c7cb8e8f08b81257bf465f949fed6e72a11631a38a000d471d7f6fb"
    sha256 cellar: :any_skip_relocation, monterey:       "bfeb72766e71c4e6745ae0f47f469bbef899338b07844031c7c4ca0307777f20"
    sha256 cellar: :any_skip_relocation, big_sur:        "df0cc90fde1acf11b225800c03d4b9099b40befa8250a7a6b700bdf7b762b1ee"
    sha256 cellar: :any_skip_relocation, catalina:       "af573fbf185b3a82ed7b3ba79cfe6a30a4c180e00e4e73fcd057ffc30d90f84b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "138e13c47315be85e1b623d428ce84db78a74ec2bb4b5aaf524daed5a6fa5c75"
  end

  depends_on "rust" => :build

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
