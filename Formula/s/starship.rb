class Starship < Formula
  desc "Cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/refs/tags/v1.19.0.tar.gz"
  sha256 "cf789791b5c11d6d7a00628590696627bb8f980e3d7c7a0200026787b08aba37"
  license "ISC"
  head "https://github.com/starship/starship.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aa460abfe797998bbeb28f307296f4c309e1d0ba520b65330b1a9d6da12eaf61"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "09dbed5fc8d4f3733f637ee89514d38a4137063a3d251de9a633af86ab75c72d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "55bda002bdfa6b15312fe28457d28dba841c95bf6321c9129fdb5f744a54bfa8"
    sha256 cellar: :any_skip_relocation, sonoma:         "2d53c7430331c0b72fdf384d26c770fa28df86791d017817e2cc8be9cd955926"
    sha256 cellar: :any_skip_relocation, ventura:        "ccedca76453826d1b3ddbe1a56edeae4f409b37f117fa8069ced3d4986d87e81"
    sha256 cellar: :any_skip_relocation, monterey:       "f81f58f9b7905d4cdce71975f3fbf92f1d325a7ab9acc6ab4cbc3233018ef198"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea23bc700fbb8907f707b82de36191cea82efcc8fb266a3eedee3b767f62821d"
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
