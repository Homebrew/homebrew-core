class Stencil < Formula
  desc "Smart templating engine for service development"
  homepage "https://engineering.outreach.io/stencil/"
  url "https://github.com/getoutreach/stencil/archive/refs/tags/v1.19.3.tar.gz"
  sha256 "bfd6e5a45f2f15bf4ae96d62305b6da646d257b13eeb060731cfca66c1554256"
  license "Apache-2.0"
  head "https://github.com/getoutreach/stencil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a575d6f2201e5718baa7bd4c35e2ac41b4b28fe756490f6ccc5c75b50d613d8e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "409f964cc96c734020e2f4c755fb9823c126c9113666097ef6999fddfb567f81"
    sha256 cellar: :any_skip_relocation, monterey:       "6ae4dad6e677043d4c6a486c2d547ca8d89bce170be32de8381c9f7e1c0a26c6"
    sha256 cellar: :any_skip_relocation, big_sur:        "b5049b9168d8ea683dcec11fd0e54279b8f07a7ffa48ca197619ba2dd504f17a"
    sha256 cellar: :any_skip_relocation, catalina:       "7884de1ce6eeca6b45783d52a330e6d70d4fda1e8c81f28c7638260c6847bddc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1cd6efe21501549bd60c2b38fd5c10c05afa6ef519dde4f96f878b2a307f6825"
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
