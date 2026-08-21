class Zizmor < Formula
  desc "Find security issues in GitHub Actions setups"
  homepage "https://docs.zizmor.sh/"
  url "https://github.com/zizmorcore/zizmor/archive/refs/tags/v1.29.0.tar.gz"
  sha256 "de3da74599a1e080361e97c0431bdc0f656ea530420fdff953a8e3d679e1153b"
  license "MIT"
  head "https://github.com/zizmorcore/zizmor.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8b834d7d8d11e8e3041d7812c04e47c64c0399277cfef9a8efac9d64b79202d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5445a999473b7a72f07369537ea0ea2d1478267db6ea5247199a94ac83799c53"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f1419c63116caa52f74e6f47840286927d984bf63745f8c7b288319386dda7c"
    sha256 cellar: :any_skip_relocation, sonoma:        "88ed937fe776f436c2a814adf73e8b64ff8bfaf61a1e1ff7bbb42c3611c8a645"
    sha256 cellar: :any,                 arm64_linux:   "78294151ed53e241e120c0d7bb4cdb79b072ee68b191ab44ad0c2f3663d63b49"
    sha256 cellar: :any,                 x86_64_linux:  "405c60019576cc173964992f39d42f50fb39b3290d99b75984e5fcf351ba4f52"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/zizmor")

    generate_completions_from_executable(bin/"zizmor", shell_parameter_format: "--completions=")
  end

  test do
    (testpath/"workflow.yaml").write <<~YAML
      on: push
      jobs:
        vulnerable:
          runs-on: ubuntu-latest
          steps:
            - name: Checkout
              uses: actions/checkout@v4
    YAML

    output = shell_output("#{bin}/zizmor --format plain #{testpath}/workflow.yaml", 14)
    assert_match "does not set persist-credentials: false", output
  end
end
