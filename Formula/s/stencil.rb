class Stencil < Formula
  desc "Modern living-template engine for evolving repositories"
  homepage "https://stencil.rgst.io"
  url "https://git.rgst.io/rgst-io/stencil/archive/v3.0.3.tar.gz"
  sha256 "93ae08d70bb6fccd6c659532963d5be49eb650f9fcf909c598ceea893d4216a9"
  license "Apache-2.0"
  head "https://git.rgst.io/rgst-io/stencil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4455add6a17576c817bfe18aab5ec4d568cbd876afd705e16cdc0465fdd7cd15"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ed9a9effc2ab07f3eca740507385e2b757a21ce236d1aab5822bc50999be8235"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6586b92e9b1033547290908d439ca1fbfa19c2efe69d1dfe11b0f39d2a7c97d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "670bf349b0286164d240cca52f2c28e1cf63efb0d99b45dcb842b50397db45f1"
    sha256 cellar: :any,                 x86_64_linux:      "539fac1652cb952966b714a090377b8ca23f1f10751f2b2efcbc34c2a5317953"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X go.rgst.io/stencil/v3/internal/version.version=#{version}
      -X go.rgst.io/stencil/v3/internal/version.builtBy=#{tap.user}
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
