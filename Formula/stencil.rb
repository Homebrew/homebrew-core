class Stencil < Formula
  desc "Smart templating engine for service development"
  homepage "https://engineering.outreach.io/stencil/"
  url "https://github.com/getoutreach/stencil/archive/refs/tags/v1.34.0.tar.gz"
  sha256 "c15e25b684f7dc2142f488f2e990c16755577501850a668659809742cafd9582"
  license "Apache-2.0"
  head "https://github.com/getoutreach/stencil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6c490dcae62e8fae0adea3bb668cbde0502165cabff5ad017bf6ecadbacc7699"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c490dcae62e8fae0adea3bb668cbde0502165cabff5ad017bf6ecadbacc7699"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6c490dcae62e8fae0adea3bb668cbde0502165cabff5ad017bf6ecadbacc7699"
    sha256 cellar: :any_skip_relocation, ventura:        "63bcde536feae4d35b69b645fddbeaa3549ed0850b85adbdce004bde8968c7c6"
    sha256 cellar: :any_skip_relocation, monterey:       "63bcde536feae4d35b69b645fddbeaa3549ed0850b85adbdce004bde8968c7c6"
    sha256 cellar: :any_skip_relocation, big_sur:        "63bcde536feae4d35b69b645fddbeaa3549ed0850b85adbdce004bde8968c7c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cce3ba0812fc22b3a9064f9000186bcb2d5362ebae9502847bd95ad96aa5753d"
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
