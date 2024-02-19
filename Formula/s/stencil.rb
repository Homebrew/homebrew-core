class Stencil < Formula
  desc "Smart templating engine for service development"
  homepage "https://engineering.outreach.io/stencil/"
  url "https://github.com/getoutreach/stencil/archive/refs/tags/v1.37.2.tar.gz"
  sha256 "c3ca3b594c1f3f0607a5e0b7b78d626ffbc72903d0d071afa45a1edfe8622e22"
  license "Apache-2.0"
  head "https://github.com/getoutreach/stencil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0b81c9954421feed65e496927f546016d9cb0e59ce0c355c15ee5e770a9dfb8d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dda8a6ad67da6147bab0aeb3f213d7c07037e2771fa10d0b5804569ad57ec0e6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a7f6a650316a0fc52338d25c33804dd76d574ac46098a088e50e5cb4f50fcce3"
    sha256 cellar: :any_skip_relocation, sonoma:         "4c529dc3a78324810224dd23d6d6aaec3581ba7957b7342d50183a5c1566acc0"
    sha256 cellar: :any_skip_relocation, ventura:        "afd8d9ad5d97e43d0262835009f95c50a778b832d77a78b11fe0fc4f791204e6"
    sha256 cellar: :any_skip_relocation, monterey:       "0bd5119a4e2659c7e165fbd2553c53278e5262fb71d900ad6d120072e4ef40f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca17aab12fca17ceede82fa3717bdb2b594ca9a9d3041ae392786507b38b14d7"
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
