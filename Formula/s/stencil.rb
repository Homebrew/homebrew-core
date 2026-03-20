class Stencil < Formula
  desc "Modern living-template engine for evolving repositories"
  homepage "https://stencil.rgst.io"
  url "https://github.com/rgst-io/stencil/archive/refs/tags/v2.15.3.tar.gz"
  sha256 "2391ed29d86b224daa920b4af64c70a6fc63e99a68ee46f98a13cffb9e682078"
  license "Apache-2.0"
  head "https://github.com/rgst-io/stencil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "68825338d7d4d937567de9f59e7617fe5c05cd913e5c178e040b9194b7e722ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd63b14c6278390399391188878c9b09dd87f9708b6d28da9467a0deebdc6d75"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0133af668b31722657a25fdfa288766de4df02cf6db72a841d8edfc8f7084f27"
    sha256 cellar: :any_skip_relocation, sonoma:        "a849544868d08b429f920d478ef9b98e49d9d1091e99d6f7caac5b5052bff38f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9e349386ab6dc5f30abbdb2afd1f74a14b9f73d1a00c300b7a902fdc4cf2e0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97437520b8e50fe587515c0dbb6902088381389dcb71e7a4de8b30333d0c8aab"
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
