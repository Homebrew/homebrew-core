class Stencil < Formula
  desc "Smart templating engine for service development"
  homepage "https://engineering.outreach.io/stencil/"
  url "https://github.com/getoutreach/stencil/archive/refs/tags/v1.23.0.tar.gz"
  sha256 "1fdd94518e7f837a9c896638c6f1cb452278e7b02055cc4a4380a087682dd4dd"
  license "Apache-2.0"
  head "https://github.com/getoutreach/stencil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a9a82bdc04c27a5397604251cf65b0064ee5bfd3bd58812bc8f78b5ebe7bb822"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "026a53d7310addbcd872a7a7dc94618f6756bed06fb8a74d8df174294387e38b"
    sha256 cellar: :any_skip_relocation, monterey:       "6d644ac50912e97de187e3543f40a75a1e6539856f55fd4e65e49ad54218a88e"
    sha256 cellar: :any_skip_relocation, big_sur:        "4607db9e030cf41e185eef5c75571dd260985709286bedec1a4e92bd7b7faaac"
    sha256 cellar: :any_skip_relocation, catalina:       "5cbef5c4f4a20e1d02ef0796bc110261ade9a803570b4a4e8956ea5032eb87bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d38d20c55733742cc412522a9787fb0b137c7a1b09fc01e81af30f4ce7223ad0"
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
