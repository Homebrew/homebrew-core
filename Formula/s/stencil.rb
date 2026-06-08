class Stencil < Formula
  desc "Modern living-template engine for evolving repositories"
  homepage "https://stencil.rgst.io"
  url "https://github.com/rgst-io/stencil/archive/refs/tags/v2.18.0.tar.gz"
  sha256 "a7168b16fec88513c9e9a804f6c640cb12df604213eae283a5798084ebf13596"
  license "Apache-2.0"
  head "https://github.com/rgst-io/stencil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d995cb764f2787c2bfe7a1d4fc3112a927aa93e26fdc6966e921630705d62f0f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4826a77887eb74c9da947d208592ae897684e102a186c90c5a65bb2f66b9b19b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9681cf79d866ea2576134fc342a82a0bb2127be4abc21acbd836ce0d392ba54c"
    sha256 cellar: :any_skip_relocation, sonoma:        "f21acb0dcdfe3c6a2f424a7ee488f614e42d111fa665c4a511348991c8e66294"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4faa9ae8ed5c5ca12bc0be4cc0d1532eaa78d5983c2e17f39ba5c26bf4141ae1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8999d661004865b5218c9737daf5522b0d1e4fdc42b70848a2e2854deaa99149"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X go.rgst.io/stencil/v2/internal/version.version=#{version}
      -X go.rgst.io/stencil/v2/internal/version.builtBy=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/stencil"
    generate_completions_from_executable(bin/"stencil", "completion",
                                          shell_parameter_format: "",
                                          shells:                 [:bash, :zsh, :fish, :pwsh])
  end

  test do
    (testpath/"service.yaml").write "name: test"
    system bin/"stencil"
    assert_path_exists testpath/"stencil.lock"
  end
end
