class Starship < Formula
  desc "Cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/refs/tags/v1.22.1.tar.gz"
  sha256 "5434a3d1ca16987a1dd30146c36aaa4371dbe1c7f1a7995c0cf12ab3eb9326d7"
  license "ISC"
  head "https://github.com/starship/starship.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c707e68e71ce0e6bbd721f40d3a6d4d413952640a85e2b4057c354181b2a7416"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18c06aa1ecc92e736f0cf18ef476eefe95bd0515110aa885506da3d3282af522"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "df88c2c2b3976851cacfab457cc693887b63f09fb3c270d992f7fd75290f9429"
    sha256 cellar: :any_skip_relocation, sonoma:        "480793d14d7014c6f3de40dac80fe11f64f225a82bddef5f92d0510d87d85417"
    sha256 cellar: :any_skip_relocation, ventura:       "5bf4c974cdcccf64dfe197a531a047290e7f3f849ddc4dcfa5fb24cbf51508e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8815fb22c318600592fa236cf612e5892adbab219ae26b007d2df2838a1e711d"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkgconf" => :build
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
