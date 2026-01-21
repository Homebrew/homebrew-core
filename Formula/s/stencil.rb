class Stencil < Formula
  desc "Modern living-template engine for evolving repositories"
  homepage "https://stencil.rgst.io"
  url "https://github.com/rgst-io/stencil/archive/refs/tags/v2.13.0.tar.gz"
  sha256 "a0aed74468d27331607b917a95157579c3fccc1b48fbba264c31cddd2d5c2a1c"
  license "Apache-2.0"
  head "https://github.com/rgst-io/stencil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "54d2449d013517de1884e95466dca63106ecc0deefda8e37735c405db0e9734e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a28be47c9a7d67b546b160d4ec2fe462b5363b8cea96cae45ba14241773d982"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8699a500eab771acdef3db0de872b17d83738e860bd0288cb3a0529d3badbc4a"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad829a6b7582bb842d0525b8d5eab658ddcd7422a684daf9eddc31023eacbba7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c701eeeeefe94c8fc82e89e9711402b0743f5cde6a977db8d5c85984e9f7ad91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c8e373eb6e564ceee22bce0249410ef5db346219cc200b557a321d9eba020e0"
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
