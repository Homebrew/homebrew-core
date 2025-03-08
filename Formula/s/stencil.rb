class Stencil < Formula
  desc "Modern living-template engine for evolving repositories"
  homepage "https://stencil.rgst.io"
  url "https://github.com/rgst-io/stencil/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "edf1f0e553c9f7bf8347dc46436e9d22db74e12726155933e97e4df3c185c982"
  license "Apache-2.0"
  head "https://github.com/rgst-io/stencil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "549622a27f4f035b4fce7ea5a92dcbf483fb12757cba29256267d7a508f0a23f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9425a0d40e7c843c1bf548c681f1bc0b02723e7eb9ed2de1af970bb6788ed0af"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f33807e2ca78650d6f15fd32533f93f4c79775dee3ba90e7e5fd12ae6d3f7817"
    sha256 cellar: :any_skip_relocation, sonoma:        "8df1bb846f5b70c78b53ed6264a5a432212c1f529285a8325649c9f49f70aa97"
    sha256 cellar: :any_skip_relocation, ventura:       "d32e6c94a43e41e361f8b92d906566e068219f0626ed1833f43c7907121bfac4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4403742d5db441ede99dd3bf79392629b152d5027b1ef390804c8396190563c9"
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
    assert_path_exists testpath/"stencil.lock"
  end
end
