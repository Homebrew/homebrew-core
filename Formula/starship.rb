class Starship < Formula
  desc "Cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v1.14.2.tar.gz"
  sha256 "6c9bee757955644453deab3564a10c0696606bb1c197ad631ff6ebbf8892b7a7"
  license "ISC"
  head "https://github.com/starship/starship.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b27b0c365275c982337951f362c4f508bf04532e1738956b18d94f6a7e14ed8d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec43c380a296ba5c318c52d42c123638d33886fb05f7ff4e4b2bed900c135f98"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "157a3a008fe687f8cf6d15e269fd48b97416bcbb624f9db3321038766ec753b2"
    sha256 cellar: :any_skip_relocation, ventura:        "7bf45efb77d274612eb6930116d41980af51b56d3aeba074b7ff3233d854e843"
    sha256 cellar: :any_skip_relocation, monterey:       "8f08b29ddfa494067a1cf619003d3acd6202600f2c992689e6df147673f1a625"
    sha256 cellar: :any_skip_relocation, big_sur:        "a100278348c84247b8a20f0492d159266e3008bed0f95a65f7ac6432b40d8b30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f61b042f9c00ddf6f330144149dd00d91e836112be65b15fa873c1de1c7289eb"
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
