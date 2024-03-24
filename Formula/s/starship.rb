class Starship < Formula
  desc "Cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/refs/tags/v1.18.1.tar.gz"
  sha256 "2ab61ae3d2e256266191f670a76a35fd06310ada2777efa0f2b6d2602071d13b"
  license "ISC"
  head "https://github.com/starship/starship.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bc963c590631893de7f87287d44d52f32f38f78529d5ea80c0c9ddff39ca93f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9e2d14af91246f06bd9709ae8d102f3ca3a31df988606ac95862357ca9169ed0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "91221245f0a31447ebe68967aad8ac39f0cd04b5e6beffb5957ea7349818c3c8"
    sha256 cellar: :any_skip_relocation, sonoma:         "6ba5ac1f4908f660a5e7830e1ea9405a010915b8937e1daf9546e0d1f0123a8e"
    sha256 cellar: :any_skip_relocation, ventura:        "c7650ee45b575679df60accfe93eb1fd28c2526f90bdfce59e8d6d451f52c182"
    sha256 cellar: :any_skip_relocation, monterey:       "e961d25e02c613e2c321b9f8f53ab82e743cb5e0f78786150e9c220e2c266703"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4160a98694f3a7495548590dbe367b4c4a59bba2f4643d84c1f290976454f9c"
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
