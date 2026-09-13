class Rustywind < Formula
  desc "CLI for organizing Tailwind CSS classes"
  homepage "https://github.com/avencera/rustywind"
  url "https://github.com/avencera/rustywind/archive/refs/tags/v0.28.0.tar.gz"
  sha256 "3094863289e70a999699898032d8c5c5e3d0f2448c6c85f84f323ca9c9e1462f"
  license "Apache-2.0"
  head "https://github.com/avencera/rustywind.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b1316c79f6e9c630d89ea059370d741398031cb5e49da4d701efaea709e4b795"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f7532e2eda66a07c25f94ab85f6a05cb660ce0e435ba95d5be71ad7ea6cb0754"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8eba343acfc22c3a8f49c35e6c79d75ea313e849554eeee746af00a2f7450424"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "1adbfb906e7501b99973715bf5b757f5622e1ae7c18d31a5010e6081e4a1659c"
    sha256 cellar: :any_skip_relocation, sonoma:            "349367a71e234910f792f87cde84c6603fa95a032ffacb0596ffd5b02f7ebf79"
    sha256 cellar: :any,                 arm64_linux:       "1f7c51e3e3b8b64ba6a11c8b707c42ce4610d9f3e9cb178e0a9804488124aa8d"
    sha256 cellar: :any,                 x86_64_linux:      "3d3303753a660fcf2a1fcd18678a039f4de4a8cebd6650ec9db8b5db136b2ed1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "rustywind-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rustywind --version")

    (testpath/"test.html").write <<~HTML
      <div class="text-center bg-red-500 text-white p-4">
        <p class="text-lg font-bold">Hello, World!</p>
      </div>
    HTML

    system bin/"rustywind", "--write", "test.html"

    expected_content = <<~HTML
      <div class="bg-red-500 p-4 text-center text-white">
        <p class="text-lg font-bold">Hello, World!</p>
      </div>
    HTML

    assert_equal expected_content, (testpath/"test.html").read
  end
end
