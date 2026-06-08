class Sherif < Formula
  desc "Opinionated, zero-config linter for JavaScript monorepos"
  homepage "https://github.com/QuiiBz/sherif"
  url "https://github.com/QuiiBz/sherif/archive/refs/tags/v1.11.1.tar.gz"
  sha256 "4069bb60326caf7d50d06d15e85e838707206f061319461867101046e4fe01b8"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d81facdf032e213d960203de863bf618c1d6a5f057698bfe14fdc7978f3d68e4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2f0eeed242d165e3186234c46d99d71a5235d8e1e47a3f7ee42ccd53087b34a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b95376ac37e29a81cddddfa69a78eee8d35308fad1dc558c7dd6f02f2984617"
    sha256 cellar: :any_skip_relocation, sonoma:        "c757836175ed5ec663e39bd6bc447ad76420875d2df55ef6051b47a77826b4d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2bf55bd7259fdf733e2f00e1c5a15b6be9227a956874fc451bb8e18ea1ffd97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1194e9f1532b1564119bae43384fefe0f92a503c86b759bfa69768575b1b6b50"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"package.json").write <<~JSON
      {
        "name": "test",
        "version": "1.0.0",
        "private": true,
        "packageManager": "npm",
        "workspaces": [ "." ]
      }
    JSON
    (testpath/"test.js").write <<~JS
      console.log('Hello, world!');
    JS
    assert_match "No issues found", shell_output("#{bin}/sherif --no-install .")
  end
end
