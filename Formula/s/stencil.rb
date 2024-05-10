class Stencil < Formula
  desc "Smart templating engine for service development"
  homepage "https://engineering.outreach.io/stencil/"
  url "https://github.com/getoutreach/stencil/archive/refs/tags/v1.38.0.tar.gz"
  sha256 "99ca1844882a4887d4780fe580a3fd071f20f396519121bd4cf60531542e5746"
  license "Apache-2.0"
  head "https://github.com/getoutreach/stencil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c2dfa664a4c7620e8679d3bd3b3920ea198bc2223c078c911fda6ec5548619ee"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c82ff656df27c085fb409378531c4f99a07faeea5fd10c9ac4b5e97cf6bb9775"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dce02bab7ffeff7e0debf7381f6d67fb6e941116f482c853a16ae698f11f4ba0"
    sha256 cellar: :any_skip_relocation, sonoma:         "f472404bf949bfb90421f492ef8c34539c5039e338498fd5e968d37eed4e6212"
    sha256 cellar: :any_skip_relocation, ventura:        "9fcc7ad8eb6463ea1c3dafcf2b53f500218308eb7dcaa76b4e3465581afd0c26"
    sha256 cellar: :any_skip_relocation, monterey:       "77f59e49ae77dc2478019b6de05ae07927fde3279ad0e141f0bac662a8280efa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3dacfbd8db901c5f791dcee25af7fc6bb3df4dc1f70d72d2eabf7cc555c8dcce"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/getoutreach/gobox/pkg/app.Version=v#{version} -X github.com/getoutreach/gobox/pkg/updater/Disabled=true"),
      "./cmd/stencil"
  end

  test do
    (testpath/"service.yaml").write "name: test"
    system bin/"stencil"
    assert_predicate testpath/"stencil.lock", :exist?
  end
end
