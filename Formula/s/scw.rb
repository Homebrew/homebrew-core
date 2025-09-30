class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://www.scaleway.com/en/cli/"
  url "https://github.com/scaleway/scaleway-cli/archive/refs/tags/v2.43.0.tar.gz"
  sha256 "cc9aabee888c671094e40ab8c17ff727fb819890fad3868c8450b626f30c75fe"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "da66c919dc3d90391cc81a993fb44efc121e16f24ded6c0d4b743476f2697666"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0643ba44ec69b7b4ad67c3d4c35fa4ea0d39ac0192e041972c2c5f16f681d4e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42e8c6cb6db39eb86b7c7fd362922d8765c736c8ae8becdf66f9c0a6f33f00e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "29acc825943dedadcf4318016e7e2c69e585809d67546b4ddc6033c272582501"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c9053452a8eaebbb1ce3fbc790cfd33e00aeedc7d48aa2dc1ac804c21d38fd2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd/scw"

    generate_completions_from_executable(bin/"scw", "autocomplete", "script", shell_parameter_format: :none)
  end

  test do
    (testpath/"config.yaml").write ""
    output = shell_output("#{bin}/scw -c config.yaml config set access-key=SCWXXXXXXXXXXXXXXXXX")
    assert_match "✅ Successfully update config.", output
    assert_match "access_key: SCWXXXXXXXXXXXXXXXXX", File.read(testpath/"config.yaml")
  end
end
