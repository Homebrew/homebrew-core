class Stencil < Formula
  desc "Smart templating engine for service development"
  homepage "https://engineering.outreach.io/stencil/"
  url "https://github.com/getoutreach/stencil/archive/refs/tags/v1.28.0.tar.gz"
  sha256 "16328f0761e7b3afce86fa8148ea43dc1401f72de8de77ad2c2305f92bf40644"
  license "Apache-2.0"
  head "https://github.com/getoutreach/stencil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a590fd1fd7ff2d6ddcf7679f5d1af987a9e29f5451aebf6c744acc143383daee"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2333a7a003057595014bd7881621bfbc809064bc5d618951dc997cc4f859377b"
    sha256 cellar: :any_skip_relocation, monterey:       "21dda9a7e6a6a12ff84916ee25df39f8b41151080931e558cc839e513639b356"
    sha256 cellar: :any_skip_relocation, big_sur:        "fdb3fcd52cc8d02c1e6d4e747a010346e469ede992abe40287edd0a8a86e5243"
    sha256 cellar: :any_skip_relocation, catalina:       "7728eea665fc248fc6ab9436ef2bf6127e804842cbecda4fc7bfaa64429cb75d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73ee309ce958848e0b266f0d67c395bf73b57d86fbb57a8c7de9b702f4b482e0"
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
