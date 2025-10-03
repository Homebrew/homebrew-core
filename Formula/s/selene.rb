class Selene < Formula
  desc "Blazing-fast modern Lua linter"
  homepage "https://kampfkarren.github.io/selene"
  url "https://github.com/Kampfkarren/selene/archive/refs/tags/0.29.0.tar.gz"
  sha256 "9882007e7b2d16023cd2c69d64d72afbee65dce7c3ab44a1527f5318667ed2a1"
  license "MPL-2.0"
  head "https://github.com/Kampfkarren/selene.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1de3f2619b86314cd483dc5c61f38109721f5dad2ae982f8348875a1ce1369a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48baf71e9c514a0a2d66cf02d5ec9eaab7e95e294f118f6dbf9f56c7cbece091"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "14fbcf98dcb3ad687d2cadefc30044dca0fbee5ce948d3d7540e2a20264d6383"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e0966eaf9bcfeccbbb73139300b199d593d47c46e6780d2c52258361cd49adb5"
    sha256 cellar: :any_skip_relocation, sonoma:        "7534a8fd3e38bc06b66066215b1614b4f7ab2955fa60a481cc9e74a2c984df1f"
    sha256 cellar: :any_skip_relocation, ventura:       "fd710434b95e8a7e81dd173454b5dffcda8d47d704f7f65d1562cbff8ede84f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8d7ef905a27b634762d82a45ff2bb070dca969729650d306d4431b3a0ebe2d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0593ac6106f4b65f587c97faef649524f83b14e2d336ce624e5f086d8e14b886"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  def install
    cd "selene" do
      system "cargo", "install", "--bin", "selene", *std_cargo_args
    end
  end

  test do
    (testpath/"selene.toml").write("std = \"lua52\"")
    (testpath/"test.lua").write("print(1 / 0)")
    assert_match "warning[divide_by_zero]", shell_output("#{bin}/selene #{testpath}/test.lua", 1)
  end
end
