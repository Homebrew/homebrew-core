class Sherif < Formula
  desc "Opinionated, zero-config linter for JavaScript monorepos"
  homepage "https://github.com/QuiiBz/sherif"
  url "https://github.com/QuiiBz/sherif/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "db9449256cfedc96c797237cc0ace54df20b8380697acef3df78787132c35d2a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d123f6dd6e4658b08d3cb2d3c41f4363bde133b2b244984b76107cfdf6debd8d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "857cdc303ce740664928d03e7101f4d94a276b016063f3c913c4ecdcfdf8c887"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7bd72050706f114c82dec5e5cf3a22cd0f43c9f600494b89a4344e4d866b29ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "c761e20868b61568c2a7b15584647597c27216513fc82878e1e00b1377f67211"
    sha256 cellar: :any,                 arm64_linux:   "7e65094a28bfac04a55bd55e27fd4b256a99549d2de141413bae459ea05b32dd"
    sha256 cellar: :any,                 x86_64_linux:  "072f510d3824d4dca8bf7bb4d9808c9c2d95f7f7a59e542ab559504a74954131"
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
