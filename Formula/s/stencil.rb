class Stencil < Formula
  desc "Modern living-template engine for evolving repositories"
  homepage "https://stencil.rgst.io"
  url "https://github.com/rgst-io/stencil/archive/refs/tags/v2.11.0.tar.gz"
  sha256 "7c239849bf083c49b8884d81cd5067a7343eda8cd048c3dba553057c3547bf5a"
  license "Apache-2.0"
  head "https://github.com/rgst-io/stencil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2f17a3914093f49adaf3cef024e652a3e8ff9e59475fa9c34cea9cb1f847a1f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d69a302755610ceda07a33a1e20a57963940266d2b82b4e68e8658df2c12c967"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "017db97fab7d2ff2c18b8c9129661a972a21d9920af25bd25133b503eb16651f"
    sha256 cellar: :any_skip_relocation, sonoma:        "ddd825dd240eadad401bb9b3325d520496bf6479650ccd147f01b5126aded6ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "119af48162f6eae754e87312ad27ca13a47dcd3763627742ea65257228be4bbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9821168e5eaf83f5e2a805a0ba029669126130e458835e52759b81833d95407f"
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
