class Zizmor < Formula
  desc "Find security issues in GitHub Actions setups"
  homepage "https://docs.zizmor.sh/"
  url "https://github.com/zizmorcore/zizmor/archive/refs/tags/v1.18.0.tar.gz"
  sha256 "17633af9cdf5ca6b5fd31468dfc3dce262b6ff85b244dfc397c484969bfba634"
  license "MIT"
  head "https://github.com/zizmorcore/zizmor.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3b792515320333d80f42d3b7c0636f2b076ba1820ac55a40c2700416126a0beb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72947af5aae0f8d0792fd5b06155c22879db6306d50452f31fec585cd8b1d99c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34c432c59fd3634c047592e39fb42b49e8132d87b32d999de008fa4ed096ddf3"
    sha256 cellar: :any_skip_relocation, sonoma:        "4522cbb16ca3d52ffc136e18bf93bae454165220962d40972e20e5711789704d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "507346f15d12ab0ca4db86874d4dffde49cd9d3d01ebd7a88eb17bdc4abe1b33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6c573104c54c73ed7e41e751906ad54eca5a116ea4095f01d792925c1915b50"
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

    output = shell_output("#{bin}/zizmor --format plain #{testpath}/workflow.yaml", 13)
    assert_match "does not set persist-credentials: false", output
  end
end
