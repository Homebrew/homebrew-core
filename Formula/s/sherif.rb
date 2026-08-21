class Sherif < Formula
  desc "Opinionated, zero-config linter for JavaScript monorepos"
  homepage "https://github.com/QuiiBz/sherif"
  url "https://github.com/QuiiBz/sherif/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "5d5f97533ecce6fc0abce023f7e6bf6490d4c4cd8042691a4ea44cd83cd0fa6d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4cb38a1b8127c958cd237731d484186f7b3177e4ae596a56b143c675e72e735c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca3f323e25e5cae7bc1073f24d0bc736ade0a786e52f02b831ad41e0429375e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b62496d7065e54232b0c26f5077a8e1671bce5448124a5462688a8381acdee1d"
    sha256 cellar: :any_skip_relocation, sonoma:        "f7b1b6341eec69b3f58bb4c6763cf10abb1c7c180abd9ec83a0ca8fcb3e0b481"
    sha256 cellar: :any,                 arm64_linux:   "b83cc581ff370265c14eed9457445326b4ffcdb6e3bd023ff5b91453d9181162"
    sha256 cellar: :any,                 x86_64_linux:  "b832f9ca5a5a306b2d5b7a86d97eb7b3643d464772f3a3cb2b3a5667cc3e760d"
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
