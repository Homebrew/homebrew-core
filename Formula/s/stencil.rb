class Stencil < Formula
  desc "Smart templating engine for service development"
  homepage "https://engineering.outreach.io/stencil/"
  url "https://github.com/getoutreach/stencil/archive/refs/tags/v1.38.1.tar.gz"
  sha256 "2b1e4a13070137a88392adb12806e34a542ee9a3aa448ebf4e80f6e5423ee22c"
  license "Apache-2.0"
  head "https://github.com/getoutreach/stencil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d163d98184a99b77fb2af587473d8faa1e5d170ed06e406697ac6f0a6c874898"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b71072096149e9984698d3ab65570c121319a20ccc5fe73eb514f503176a0ce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb0efd2d0300a3a26d70ec5000579ccb1ab384eca054b658d991fbb8dea9c4e0"
    sha256 cellar: :any_skip_relocation, sonoma:         "c462e22df00538144d1c3525fc3ed63f98f50fe5e14e528aa7eef39a34d54da4"
    sha256 cellar: :any_skip_relocation, ventura:        "959ba1e815f43366ad931660de4695590c46b5e5b8056475099e70a5071677f5"
    sha256 cellar: :any_skip_relocation, monterey:       "870281756c78972050e827f2cb9e60448bde103ee4acab93230a4ecba4f684e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00e17a9df7c7408ddfd840e9f9995fed33e5fda1282bdef17240846dabecc633"
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
