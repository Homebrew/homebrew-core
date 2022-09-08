class Starship < Formula
  desc "Cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v1.10.3.tar.gz"
  sha256 "39c5f8f88a8aa6d32575ddb26017572f2683fae129b9be5442acbae74019ea5e"
  license "ISC"
  head "https://github.com/starship/starship.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e4b8dbf9860a6ee6f60ce544ac4eabd8ec2a0ebd4a99767c29a9c859a4b06fa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "483896718eca3db5b201a5b8fcb3d36c73df44a53042606e3e2c820c1cae0104"
    sha256 cellar: :any_skip_relocation, monterey:       "71f0d7ccd86a52c93ce010984640ab1c656b6791f128b0fe1abf547316deb62d"
    sha256 cellar: :any_skip_relocation, big_sur:        "3c3cadda8735bdb50f07553d4f94bd5199376cdf0a024acd9db82d95505c4e93"
    sha256 cellar: :any_skip_relocation, catalina:       "13c3f95288be8114998dd8b1f70df6e1333b3c1ad0b6e81fb1f941f90d366397"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14397ea73067009b5f0de9acfac7236c9456e3124d00a7d5ce6c965edb18884f"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "dbus"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"starship", "completions")
  end

  test do
    ENV["STARSHIP_CONFIG"] = ""
    assert_equal "[1;32m❯[0m ", shell_output("#{bin}/starship module character")
  end
end
