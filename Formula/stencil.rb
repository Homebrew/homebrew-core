class Stencil < Formula
  desc "Smart templating engine for service development"
  homepage "https://engineering.outreach.io/stencil/"
  url "https://github.com/getoutreach/stencil/archive/refs/tags/v1.19.0.tar.gz"
  sha256 "90be48af7ee73dcce02e9c3089374494562246e5dfd1ac21b4fa0b5980e69c98"
  license "Apache-2.0"
  head "https://github.com/getoutreach/stencil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f5c816ee35c734eb40c6e01fe7bdc5727f1335aee14d4f0227aadb1d78c59007"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "394753e420949002a214f4e0357313716c018a1de83e1d5fba580c1b39ccdb2f"
    sha256 cellar: :any_skip_relocation, monterey:       "10bdb78f01430fbeef0182deea486129ffdf42b6ff525ec6c2e45dfe30f1a60b"
    sha256 cellar: :any_skip_relocation, big_sur:        "c6ef29b7e7cd43b83c28269110c738d0549bad868c564b395611db135b0b2690"
    sha256 cellar: :any_skip_relocation, catalina:       "193ebacc0cfb15b1c982729685b9636a6dcd34639f13ba39256d1e8ece5a1b56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "155ceda91239c64be5c9d1161205b303f8d6229278f6b44035bed4d155ecb29d"
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
