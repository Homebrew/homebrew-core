class Stencil < Formula
  desc "Modern living-template engine for evolving repositories"
  homepage "https://stencil.rgst.io"
  url "https://github.com/rgst-io/stencil/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "3a281bca9d895e8b1945e441f3671dacdbc8651bb02685e52019ac0333b0f374"
  license "Apache-2.0"
  head "https://github.com/rgst-io/stencil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7aafaa0c5f36fd0e520f53dc690e1ad9dec81ac482096f1959451e4008632feb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a3c16040bfad1cde26531373eae1f172c7685b218919ac76c923fc4c26a15b8f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "18620d3518406d2ba2663f63f0b59e6c0a1eff790a05f8b39f48bc08cb4354e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "c7f9e6b901190997497e7d9166687f06906946c5b9ef1465eb454ef8f06b08b6"
    sha256 cellar: :any_skip_relocation, ventura:       "8bf00aeac4a32ebd441b88cf7d706612cffd2ea778f1f6b933bba12b786e8673"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0e47e164119b7b6392a97d14b666b906fca96cc4f9f6d6c9cc5e40a6584053a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X go.rgst.io/stencil/v2/internal/version.version=#{version}
      -X go.rgst.io/stencil/v2/internal/version.builtBy=homebrew
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/stencil"
  end

  test do
    (testpath/"service.yaml").write "name: test"
    system bin/"stencil"
    assert_predicate testpath/"stencil.lock", :exist?
  end
end
