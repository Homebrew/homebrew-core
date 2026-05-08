class Stencil < Formula
  desc "Modern living-template engine for evolving repositories"
  homepage "https://stencil.rgst.io"
  url "https://github.com/rgst-io/stencil/archive/refs/tags/v2.17.0.tar.gz"
  sha256 "38b956d91d3e239e4d4fb908def46b995cdf32609697c529a56868398b261a03"
  license "Apache-2.0"
  head "https://github.com/rgst-io/stencil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cef1067e4f299c3939429ff5b8c0aeba398a7b2ebad5f4e7d3ff6b278a03e0f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "688ba51f214d453c30c8b61df1e1b80681c0084e6b48ffe8af1352f778916a75"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7308364af6b18a39ed0b947dde09ce657ddd6449e4c39fc8478a5bbb9b608761"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b261490b57d01389a2642eab832534648dd345d2dc20c0dd72b21573a9f7163"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56b9fe7a78395963dc4ebbb54243fa2baeb7b89e5025540bfd073683d172697f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44fb8b28171463ae8ae903eb38501a9d6299ad626b0689541630692eebd15101"
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
