class Thriftgo < Formula
  desc "Implementation of thrift compiler in go language with plugin mechanism"
  homepage "https://github.com/cloudwego/thriftgo"
  url "https://github.com/cloudwego/thriftgo/archive/refs/tags/v0.3.19.tar.gz"
  sha256 "9c43535bd1d783965649dd7ebb1c50dded05a3b031e4e126275c958b732a45ce"
  license "Apache-2.0"
  head "https://github.com/cloudwego/thriftgo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c5a49664eb60e348c1f782e0f5afcb8204c931b938e02feb53d5dc167512d6f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c5a49664eb60e348c1f782e0f5afcb8204c931b938e02feb53d5dc167512d6f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8c5a49664eb60e348c1f782e0f5afcb8204c931b938e02feb53d5dc167512d6f"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce698cd1707511318f8d6e47f28c69312a2182e4925ca7d9a86b8f90b86d9620"
    sha256 cellar: :any_skip_relocation, ventura:       "ce698cd1707511318f8d6e47f28c69312a2182e4925ca7d9a86b8f90b86d9620"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33c4d6fe440ee8bd15020d233ae29e3acbbd69df77a221985b61b6f4c6942d35"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}/thriftgo --version 2>&1")
    assert_match "thriftgo #{version}", output

    thriftfile = testpath/"test.thrift"
    thriftfile.write <<~THRIFT
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
    THRIFT
    system bin/"thriftgo", "-o=.", "-g=go", "test.thrift"
    assert_path_exists testpath/"api"/"test.go"
    refute_predicate (testpath/"api"/"test.go").size, :zero?
  end
end
