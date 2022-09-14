class Stencil < Formula
  desc "Smart templating engine for service development"
  homepage "https://engineering.outreach.io/stencil/"
  url "https://github.com/getoutreach/stencil/archive/refs/tags/v1.27.1.tar.gz"
  sha256 "7d1c410183f42ea74425e9068cf85b3ff7c644ab2045164ba3371c7f39b03669"
  license "Apache-2.0"
  head "https://github.com/getoutreach/stencil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a550c31303d42da301ee1f96bbcbffac3bc96891ef03b9b04ffe64c425b5ab30"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dd31200acf1fee5c60aac4225688fa1980ec5d8459a7fab5bd506bc62f5f7b1f"
    sha256 cellar: :any_skip_relocation, monterey:       "c4e956d9144348617f2537abb49d64297759147113f2ca5ccedb113e419346ee"
    sha256 cellar: :any_skip_relocation, big_sur:        "b6527986c97a852ffb3cddc13a9bda76e51929366bf30fea5204ececd415e2c4"
    sha256 cellar: :any_skip_relocation, catalina:       "ca9bd3a861498fc6523b5a6b9208f922aa9cad06f668c5e20dfef55d861102de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99eb1c6a116e6620f70fdd5410b218e1addfd59c532273d74b87f770bed14b61"
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
