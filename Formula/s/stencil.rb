class Stencil < Formula
  desc "Smart templating engine for service development"
  homepage "https://engineering.outreach.io/stencil/"
  url "https://github.com/getoutreach/stencil/archive/refs/tags/v1.36.0.tar.gz"
  sha256 "a89556d78ea38d2284520b43b3de7e999f11722fccde7996fd02d2f65bb23ce8"
  license "Apache-2.0"
  head "https://github.com/getoutreach/stencil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d768371f799b16ac19cabf5c5853dba3fe1b226d1a75187ba0c706bb4a7bd4ba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d768371f799b16ac19cabf5c5853dba3fe1b226d1a75187ba0c706bb4a7bd4ba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d768371f799b16ac19cabf5c5853dba3fe1b226d1a75187ba0c706bb4a7bd4ba"
    sha256 cellar: :any_skip_relocation, ventura:        "8a850ec7f204eb992b644b4ca453334437bd61d56418a134936623d489b9e32b"
    sha256 cellar: :any_skip_relocation, monterey:       "8a850ec7f204eb992b644b4ca453334437bd61d56418a134936623d489b9e32b"
    sha256 cellar: :any_skip_relocation, big_sur:        "8a850ec7f204eb992b644b4ca453334437bd61d56418a134936623d489b9e32b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45feae1ca215171adecfbf6574d590e4aed2fd1cabd50e78bbc92fe0b923d881"
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
