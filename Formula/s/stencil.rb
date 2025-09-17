class Stencil < Formula
  desc "Modern living-template engine for evolving repositories"
  homepage "https://stencil.rgst.io"
  url "https://github.com/rgst-io/stencil/archive/refs/tags/v2.10.0.tar.gz"
  sha256 "7c16da3086b2d95b442245bf3e1645fa15d863ee4320a803e847b54a04ec7e1e"
  license "Apache-2.0"
  head "https://github.com/rgst-io/stencil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1e4780fdf53c70a66f5f616da2bf96a3391cfdc06f55ed22d3039b532250086c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29810c303246764a46a56b3bcadcb17f58c2ebd460ed9ac24cbc549dd1ed6d86"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "869c7ebd29b14dab46ecdd1ddf99a699c0f0fe23b34450a10601ec826d5e64e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "d5aa7ad18e00900fead664cd2694dcb9d8153faacb284af99c550e3d71cc82ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "01581948a36f2d2a1ac244ddb7d4b3f3db45001ab2b331241de27f248649b5a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e7c2222616c6535413b825d13217bc5748c964613dd0d8cef9a4dcdca6cef8f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X go.rgst.io/stencil/v2/internal/version.version=#{version}
      -X go.rgst.io/stencil/v2/internal/version.builtBy=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/stencil"
  end

  test do
    (testpath/"service.yaml").write "name: test"
    system bin/"stencil"
    assert_path_exists testpath/"stencil.lock"
  end
end
