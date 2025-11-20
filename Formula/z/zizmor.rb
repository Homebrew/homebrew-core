class Zizmor < Formula
  desc "Find security issues in GitHub Actions setups"
  homepage "https://docs.zizmor.sh/"
  url "https://github.com/zizmorcore/zizmor/archive/refs/tags/v1.16.3.tar.gz"
  sha256 "0953b0bd6016b929a743b18e693b9cf8e0f2766e53531a64134f6d762965e933"
  license "MIT"
  head "https://github.com/zizmorcore/zizmor.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a835b233d8f0248e1af795431e77967f8872bfc26cf195e14a9f2956cd87cb67"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dacf4c1548062e6dad38902033950c7ef540122efdb2f2db859622f79c6048e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "762de93c0528bb4ce2bffbec96fdb014267a7f0372dd21d171b83951a6ccdc90"
    sha256 cellar: :any_skip_relocation, sonoma:        "29c547010083e8509f1f31f49dcfbed3cef60a2178e6ab7e3dde8dc94fc9f055"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e8c36d7965f2be733eab4ee5f6ce0d1af62e9166547fbc1d07c5169202e37d39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64b70f2ea15bbc86061fa86d712ca00523f089a1a959df75ac8b5363610a0539"
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
