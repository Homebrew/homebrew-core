class Starship < Formula
  desc "Cross-shell prompt for astronauts"
  homepage "https://starship.rs/"
  url "https://github.com/starship/starship/archive/refs/tags/v1.24.2.tar.gz"
  sha256 "b7ab0ef364f527395b46d2fb7f59f9592766b999844325e35f62c8fa4d528795"
  license "ISC"
  head "https://github.com/starship/starship.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "261c37914c6e39b9f05633501ae38c7c44d0784a4886941a23f15bd6c49f7faa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "afffc7a2bf021cac23ee10af2cee207ac2e16d193425935a34d3f58eb276da52"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1bb0af009b2965ec7b6dd8410f068c90a7ba4c017b71243613185a7517c4540"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2751c138704236385e82030494728e08b839fa5935a38aab40a8bcc5ae9ca31"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ca52b67cf4b6f3004cbb3977d11923787ec17763cff6f448a339ac5643c1395"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "493d58232e62a9ae7ef86d039d442b7463495a907ffe14cb795cc590fadee3cb"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "dbus"
    depends_on "zlib-ng-compat"
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
