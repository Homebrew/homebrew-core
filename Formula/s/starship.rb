class Starship < Formula
  desc "Cross-shell prompt for astronauts"
  homepage "https://starship.rs/"
  url "https://github.com/starship/starship/archive/refs/tags/v1.24.1.tar.gz"
  sha256 "4f2ac4181c3dea66f84bf8c97a3cb39dd218c27c8e4ade4de149d3834a87c428"
  license "ISC"
  head "https://github.com/starship/starship.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cb9678a4b4263db0615c702a783515df4858f9f8c752ada86442e47d27ebb71f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19495f6ff227f91835a33f0fb03793ef3d7b17448130dad2944edc5ff1df635c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7854f463031c39cc9e4c9f19276e5109b74e7de4507795fdc9821d9a1d15c16"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f6d043e8b7aa529c887a750377940249f3a84e01e985dac4dc11b2d591dc609"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f3f1fdf700cb97b8472eb91b01afafc265132cbc91c0bc95f8ccd3ddf6c15dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b864879c3a5a2a8421f468a074df2c80976a20bc4ff7b47f064b0a6b8bd96be8"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
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
