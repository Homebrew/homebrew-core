class Stencil < Formula
  desc "Smart templating engine for service development"
  homepage "https://engineering.outreach.io/stencil/"
  url "https://github.com/getoutreach/stencil/archive/refs/tags/v1.31.0.tar.gz"
  sha256 "3de265b06d597206fcad98fd1b936dba51f15e08dfa943e32b9ed64001244b2a"
  license "Apache-2.0"
  head "https://github.com/getoutreach/stencil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "651a2513d70ff60c9f50541e35f061a431b5b68cce4c45db2a18d529590c1c0b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dce501ce9de09e66eaaee0d0106ce84ce027cf02f88e6d7c364f518e8fa4e295"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a8ce8c42bf87a432c8994bed8b42a3d48948b33f763e77ebd7ec263facc88bc0"
    sha256 cellar: :any_skip_relocation, ventura:        "4135c2f0fc8c4259867090d153b87011caa92e3415ea6dd06b6d6b779aa7a225"
    sha256 cellar: :any_skip_relocation, monterey:       "7f01aae4aaea5215a2fdaa029c0e2cf18737570fe2f530471f8b6f736d03d10c"
    sha256 cellar: :any_skip_relocation, big_sur:        "a059cbd169bba2510714d02e7c097422efca3eb53d11550962e4abfb573e3742"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59ce7778506b67f6d69f1e9d77e93932add0fbedd5bdd4dd63c366a67beb78ac"
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
