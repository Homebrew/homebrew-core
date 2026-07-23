class Stencil < Formula
  desc "Modern living-template engine for evolving repositories"
  homepage "https://stencil.rgst.io"
  url "https://github.com/rgst-io/stencil/archive/refs/tags/v2.18.2.tar.gz"
  sha256 "de2d799a906f6c0b77373780a3dff242762a96da83469e12b1f06064563f7f46"
  license "Apache-2.0"
  head "https://github.com/rgst-io/stencil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5d6af811e0e86b4964ad09055270f402fd9e415b4afe24f33203488484151dc0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "663a72ddfb7b3ca036c00ded3dc2c33296a89f9390ba5464431df0b0cfe5e6bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37550a28224a9127b31dea0b9098ae8edc4be2cd30b7c8d77184dc8eea8c5dab"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b21958ddc906133816d8746b07412e039c79d317cb4b7091d48edff658f8059"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "123f5538efd74e7d4aac9c22fdc971ec03e6f9e5011e6f68d894df18545d715c"
    sha256 cellar: :any,                 x86_64_linux:  "1c265d15519770549f8913c04101d2a3130a0f00a467114e57ceae38338b96e7"
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
