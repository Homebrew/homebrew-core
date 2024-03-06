class Thriftgo < Formula
  desc "Implementation of thrift compiler in go language with plugin mechanism"
  homepage "https://github.com/cloudwego/thriftgo"
  url "https://github.com/cloudwego/thriftgo/archive/refs/tags/v0.3.7.tar.gz"
  sha256 "97f475df09baf7fb3b7e7e187373cb26bd199f10c1b62e489002a3b0d334cdcf"
  license "Apache-2.0"
  head "https://github.com/cloudwego/thriftgo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4785d3592d7b5fd89e87baaf38703126658a0d1a258ce9bc37fe1198a3687ff3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c9825f59d8155217e2eb7b56d45a2e889674911a97934ee292d95f5b8d667595"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6208b670ae63296261a83fad093e62edf7a115520c5db4ee808a6c95714fb330"
    sha256 cellar: :any_skip_relocation, sonoma:         "b4f9cf88a279bfc31a323d935ecc34311315b39a6428366af72356d1dca48b2b"
    sha256 cellar: :any_skip_relocation, ventura:        "d3bea4f992b01f22cce9f71c7a1a48214756980a7aab5327f714618047f44864"
    sha256 cellar: :any_skip_relocation, monterey:       "3f9a6f45fe37cf61a8e7b4cde56fe8d2e054e91aa77647f58670013101923d75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b775c2f0aad0f04a17466946d1d5633dff69eef22c30d3bd6bf11320f5a8a165"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}/thriftgo --version 2>&1")
    assert_match "thriftgo #{version}", output

    thriftfile = testpath/"test.thrift"
    thriftfile.write <<~EOS
      namespace go api
      struct Request {
              1: string message
      }
      struct Response {
              1: string message
      }
      service Hello {
          Response echo(1: Request req)
      }
    EOS
    system "#{bin}/thriftgo", "-o=.", "-g=go", "test.thrift"
    assert_predicate testpath/"api"/"test.go", :exist?
    refute_predicate (testpath/"api"/"test.go").size, :zero?
  end
end
