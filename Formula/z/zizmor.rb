class Zizmor < Formula
  desc "Find security issues in GitHub Actions setups"
  homepage "https://docs.zizmor.sh/"
  url "https://github.com/zizmorcore/zizmor/archive/refs/tags/v1.30.0.tar.gz"
  sha256 "7398a8a4895a7051d6654e1ee7aa6d680a69da5174aba69bf45b73d767329166"
  license "MIT"
  head "https://github.com/zizmorcore/zizmor.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d55127e1281dde2253a562174f1ff30e131f8623f1c6a75c3f08a8d3612ca4dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90e7bb0e35a9e4585bcf5f6be54900d18c65b605b24b965a623a9632598c7dd2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2fcf3f9ed3d11d225ffbf727ba7c3ee3ac15d63d9d7117a4a3b889681c7b032"
    sha256 cellar: :any,                 arm64_linux:   "517d0b2ff28b7515f7ea35d4ebbbe1ea43b55c9d3032367597433ad7436d7226"
    sha256 cellar: :any,                 x86_64_linux:  "4b631a24adb547c03334022cbf0db3d49a939e5e3da17cf9c21cf61a8faae3ea"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked", "--target", "host-tuple"
  end

  def install
    system "cargo", "install", "--offline", *std_cargo_args(path: "crates/zizmor")

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
