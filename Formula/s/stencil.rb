class Stencil < Formula
  desc "Modern living-template engine for evolving repositories"
  homepage "https://stencil.rgst.io"
  url "https://github.com/rgst-io/stencil/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "acaf1cb4d0b4e965da02d87718f09ad411e662f56a762aa19a044213bb274bc2"
  license "Apache-2.0"
  head "https://github.com/rgst-io/stencil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf04d3fd293422a6a8bccfa9b5552952f79153e195b9086ca96740049fa51a7b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f9eff63aca297c11671afe7010a2f87d7f616bd8d75a47c39f6c28a47db2680"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5bbca19773ad03fd52b07b9ad7419ba067ad0815111924e6919711b32844d5bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "39407eb7a66cef5a7c1d39be5a91a1097f5f7bd52d89c9320029d53df1726911"
    sha256 cellar: :any_skip_relocation, ventura:       "8ed509a19be6d35a4cc6d6c86ccb5b4d45d7f6b51130590af0aa888f1ad14642"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15089cd06fe65d3b0fbbb3cfdbf324d0895db3125564358098ace4418a3d09ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05563d0b5b1e5ae620e71cfbb93674aa9437b9ef065e9bec42fac919528902fb"
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
