class Trunk < Formula
  desc "Build, bundle & ship your Rust WASM application to the web"
  homepage "https://github.com/thedodd/trunk"
  url "https://github.com/thedodd/trunk/archive/v0.7.2.tar.gz"
  sha256 "ec6ee6fcbf75d0baffbc1e7a29f889b84424cbedeff3806a76470a6e0564a99d"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/thedodd/trunk.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8792cb8b3d878d5f3eb5a125720e3241358852f89684b90674ef7625781332c0" => :catalina
    sha256 "23152ec74bda2ab62f646c56304c533454217a2fb5291f676339247efb6a0f8e" => :mojave
    sha256 "68b6bc386726f1f8539a0d89046f8cefcc532ee5559fda1f38ab4a57046de9ef" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "ConfigOpts {\n", shell_output("#{bin}/trunk config show")
  end
end
