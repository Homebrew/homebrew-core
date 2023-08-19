class Trunk < Formula
  desc "Build, bundle & ship your Rust WASM application to the web"
  homepage "https://github.com/thedodd/trunk"
  url "https://github.com/thedodd/trunk/archive/v0.17.3.tar.gz"
  sha256 "74ecf8200df2d89e5f820592f73b495f1f590a2c39d18af446a7607bee9597d0"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/thedodd/trunk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e20d1e59dc39c890fc7893d4261113e05993d8d1487263215f549045d248b1dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "169a837485e90bbafd8a6ae26c2c12a44296f2474c1d6b3daa5f64aa07e1bdc9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ff1a5e1212d6e6bd5163e54ae5a28a6f6c5a8e55e2cf53cf3fc0f93df740bf64"
    sha256 cellar: :any_skip_relocation, ventura:        "1da5523be235da7fae01732f145b267c2554e60b1bdefa1ce9a37971d6cfcf3c"
    sha256 cellar: :any_skip_relocation, monterey:       "1ea0ed64378c7b2f29ce254ca875737b2101cbf72934cfb77ffaae75cdad713f"
    sha256 cellar: :any_skip_relocation, big_sur:        "e92b456d00f33ec98fbae5b9823ba8eea9c177c81e510ab6e161e47862b4908d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff3ad2b52f6d534565ceff4c855ac40024209e117e7888d824f55e804c0eb0b6"
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
