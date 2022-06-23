class Stencil < Formula
  desc "Smart templating engine for service development"
  homepage "https://engineering.outreach.io/stencil/"
  url "https://github.com/getoutreach/stencil/archive/refs/tags/v1.19.4.tar.gz"
  sha256 "1c9229b5d2f2130404029e69fef1938841710ed2c9d176804ab4ec0fdd157e11"
  license "Apache-2.0"
  head "https://github.com/getoutreach/stencil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cca5c5dce389e47beda1766a64d3e51f949a40c2560c74034cd9f92f155a0cf1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0316d312dc7c05c3415ad4a6f73c76d17907b408f2898dc9e28726f4c183045c"
    sha256 cellar: :any_skip_relocation, monterey:       "8d93a86de3610b54cd29daf0aa58797b65da25c527612ba81a75d3bcc95de546"
    sha256 cellar: :any_skip_relocation, big_sur:        "352459765d91abc3271304748e079dbbbbe5d375bf5a7ce4d43b994ab47c03e9"
    sha256 cellar: :any_skip_relocation, catalina:       "6ab57781d99ec0c0ef2b9bb2ac6e43de67d316fb90bc4c9881b97270fc2a3f96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b137d8b6cf40337dd4a3a04522aad9c7192d58e740a0a6fa1ecc29859aeb5f2b"
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
