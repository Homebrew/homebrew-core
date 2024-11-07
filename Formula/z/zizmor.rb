class Zizmor < Formula
  desc "Find security issues in GitHub Actions setups"
  homepage "https://github.com/woodruffw/zizmor"
  url "https://github.com/woodruffw/zizmor/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "25e1c2ca756ec08be0cc7a819d649dc971078774a0d5bd089ab4987a53cb4caa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b94edc5fb4a6469c772da312be72962c8196a280dcf7edf9a85bcd8b68459e3c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec35d7432623b9f0cbf4a251569c0c9442981304c28d0e353d32e885ab269cbb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3e1f19f39542c6857242ba3e8eff464995174c204262ef69a7bce8be4be2132b"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a93dd82acc9c67923a7df621bd45348c550923205e377ff613f52dea4a32ea6"
    sha256 cellar: :any_skip_relocation, ventura:       "8f37089dfdea8f5f6eaa4aca3432589e7f5900cc3bc48af0daee1df6b5e90398"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8239b4027e14493fdf95986f68e2e92f60818d58ab3a59f3a60843c23b5ec98e"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"action.yaml").write <<~YAML
      on: push
      jobs:
        vulnerable:
          runs-on: ubuntu-latest
          steps:
            - name: Checkout
              uses: actions/checkout@v4
    YAML

    output = shell_output("#{bin}/zizmor --format plain #{testpath}/action.yaml")
    assert_match "does not set persist-credentials: false", output
  end
end
