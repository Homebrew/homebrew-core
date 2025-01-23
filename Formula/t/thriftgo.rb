class Thriftgo < Formula
  desc "Implementation of thrift compiler in go language with plugin mechanism"
  homepage "https://github.com/cloudwego/thriftgo"
  url "https://github.com/cloudwego/thriftgo/archive/refs/tags/v0.3.18.tar.gz"
  sha256 "f3985b20cae4f4e52cce559ad9b9d9fcde4af84e9cb867a1f3a83dc49b9f0a8a"
  license "Apache-2.0"
  head "https://github.com/cloudwego/thriftgo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c6c5270b2b94f160e70ffb2cc833968fbbeeb96089eeb647477b69efbf18cd80"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c6c5270b2b94f160e70ffb2cc833968fbbeeb96089eeb647477b69efbf18cd80"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c6c5270b2b94f160e70ffb2cc833968fbbeeb96089eeb647477b69efbf18cd80"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c8b5217bf9d0d891e5fc5d901f862f5d63ab7cfbd313b2de1344f96553523f6"
    sha256 cellar: :any_skip_relocation, ventura:       "2c8b5217bf9d0d891e5fc5d901f862f5d63ab7cfbd313b2de1344f96553523f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab12f0ffd14c2d0402873ef2318e4e53951f8fc676a3cf6dd00f9d3601edf09f"
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
    assert_predicate testpath/"api"/"test.go", :exist?
    refute_predicate (testpath/"api"/"test.go").size, :zero?
  end
end
