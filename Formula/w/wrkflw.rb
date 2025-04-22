class Wrkflw < Formula
  desc "Validate and execute GitHub Actions workflows locally"
  homepage "https://github.com/bahdotsh/wrkflw"
  url "https://github.com/bahdotsh/wrkflw/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "d8f2652587317c07dbb146654955774edd61b79abf9232b261ba0641d0da90d4"
  license "MIT"
  head "https://github.com/bahdotsh/wrkflw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "06e62080c7571c442183998c02ef075be5d22d7001a7ae4fb9a6f8a253a79ad2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "57e3a4e16310b7ece6cf5b1e040999aa5dc3bd2e945f3e46a5b83d63aaa50e2c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2c84fe3c5dea486dded0ae9a833be74dabae399fa82d79d505203c47abd24c10"
    sha256 cellar: :any_skip_relocation, sonoma:        "2824fa1b316132df7d9499e2259298b32e1f2eb70096098158459affc931f30d"
    sha256 cellar: :any_skip_relocation, ventura:       "197b230fe07bf13db3781c81961ce7c41a3dea6a3b0a9565a6a1872db000a917"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ac3d094b2f926c3ed55a33e76fdf305880c39dcd84d4ffde665345737739a8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "124942cdeee15a286a94762048e3162285f56e59b67d535ad99cbd0340d8d68d"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wrkflw --version")

    test_action_config = testpath/".github/workflows/test.yml"
    test_action_config.write <<~YAML
      name: test

      on: [push]

      jobs:
        test:
          runs-on: ubuntu-latest
          steps:
            - uses: actions/checkout@v4
    YAML

    output = shell_output("#{bin}/wrkflw validate #{test_action_config}")
    assert_match "Summary: 1 valid, 0 invalid", output
  end
end
