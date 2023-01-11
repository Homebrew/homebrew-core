class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://github.com/scaleway/scaleway-cli"
  url "https://github.com/scaleway/scaleway-cli/archive/v2.9.0.tar.gz"
  sha256 "33a3490ab4be9053b3e4a034a6bf1c5326b435a70240ba283da571b9e2f9c512"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b5b3d2f142d29cabb016f6a002b08c7455e1cf01c92c3490bd38bd1f4894d51a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3415e1213638e5197844dc7e9126cb697ecabdf5d412c7f7d19df3cb632fdbdb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cac80abe2d36b9b93b74f49ea9571ac04b6ba0f76c413752b3654cb7d8bbeed0"
    sha256 cellar: :any_skip_relocation, ventura:        "1de28782f399d4281454244caaa665210827e468bc0455ccadead6be949aa948"
    sha256 cellar: :any_skip_relocation, monterey:       "aa46181aa6518058f3f4ff8511828851430ce7e94cb5deea1eab85eee9a09aff"
    sha256 cellar: :any_skip_relocation, big_sur:        "4f8aab56db67d7bfaff130928cae0b3560a69d30e08107cd081006da143b094b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82e2915083a3b1d6d792eef944dec013e22abe320917f08d76885e446e181b15"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.Version=#{version}"), "./cmd/scw"

    generate_completions_from_executable(bin/"scw", "autocomplete", "script", shell_parameter_format: :none)
  end

  test do
    (testpath/"config.yaml").write ""
    output = shell_output(bin/"scw -c config.yaml config set access-key=SCWXXXXXXXXXXXXXXXXX")
    assert_match "✅ Successfully update config.", output
    assert_match "access_key: SCWXXXXXXXXXXXXXXXXX", File.read(testpath/"config.yaml")
  end
end
