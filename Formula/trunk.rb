class Trunk < Formula
  desc "Build, bundle & ship your Rust WASM application to the web"
  homepage "https://github.com/thedodd/trunk"
  url "https://github.com/thedodd/trunk/archive/v0.9.0.tar.gz"
  sha256 "a5ee29cbd90e9623981e8d2acf6887b4f0eb00bd4ffad647eae7f030a2dfd926"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/thedodd/trunk.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "12484648f0ab5ed28e60fcc99acb9d3c41539368356f9d6f06683b2c67fd8ae7"
    sha256 cellar: :any_skip_relocation, big_sur:       "08662902278429cd0e44b8d83ed3b197af206e9db02afe342e6518a46c2059ea"
    sha256 cellar: :any_skip_relocation, catalina:      "636a9e27fcf1f2242d01200ee381ec6e23a7dd4842747ef29023aa4f29107ad0"
    sha256 cellar: :any_skip_relocation, mojave:        "fb6c25d1bcfa3c41aac84cd57d140be2a78199e4868b0f52cbbd440dbc801a5a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "ConfigOpts {\n", shell_output("#{bin}/trunk config show")
  end
end
