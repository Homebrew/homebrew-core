class Stencil < Formula
  desc "Modern living-template engine for evolving repositories"
  homepage "https://stencil.rgst.io"
  url "https://github.com/rgst-io/stencil/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "5c195609ab5b51b2061c2dfbfa3f7902cccff14c05fdb0f1ab8d2ed21ca437cb"
  license "Apache-2.0"
  head "https://github.com/rgst-io/stencil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "503f0f67cdcaa6fa8d1e5e8156d3347faf6bb02ddf63479cc9410670d0c49b7f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88eb915fd07d906ebed43856784e76c8ccff3b88f1df9e7053baaad83e603927"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "96286502a92b5cc7b9445193d372742bc652d48da5391188994367b123c587eb"
    sha256 cellar: :any_skip_relocation, sonoma:        "1329897ff5d337d263a579f1bdaf75c2d32f79159fb84d0f19ce50889e30a402"
    sha256 cellar: :any_skip_relocation, ventura:       "b5fd1cbb947f995367d51d4251ddd6f031e457bbd84d1f9039aea42453acc05b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "429a89da28aabe403118052a95c45b089b4a15d0cf2040ce473100abf86a938c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d99c08b3cec0a66bb98d9f8233d4601416ef4f1b64ae21a18f23993fd37e324"
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
