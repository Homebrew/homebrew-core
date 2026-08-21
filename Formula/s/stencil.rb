class Stencil < Formula
  desc "Modern living-template engine for evolving repositories"
  homepage "https://stencil.rgst.io"
  url "https://git.rgst.io/rgst-io/stencil/archive/v3.0.0.tar.gz"
  sha256 "b690da33cf271b33e479b9d40f0763bd7dfbfe7dc8dc7fc00fc32d481c329c4a"
  license "Apache-2.0"
  head "https://git.rgst.io/rgst-io/stencil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0a551b284ff04bcdbe0c28b46cfe8893eea083ea54ca3a9d95ed3f3e75621325"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3fc4abc2fdede423bc19679f7231f4677aeb8057bdef5e0f307981b6a8bbfb18"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd5140d3690bd6414174d27cec1ee3221e97b06a415ceec684286d8ef7ba14ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d7d6174207b8a786fd0148069c3b6a7c5fa38c5e2fc78f3cf34dbac3dccb452"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb6b85b1b2eef23c6584017cdf1231fda0be4ae53d049e8e9ec04d1c9154ea32"
    sha256 cellar: :any,                 x86_64_linux:  "0f751736f51cb30545e05cb45d3bc4b63f63550fa814e57a82fea3999e95d6bd"
  end

  depends_on "go" => :build

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
