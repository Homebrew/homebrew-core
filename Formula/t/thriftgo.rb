class Thriftgo < Formula
  desc "Implementation of thrift compiler in go language with plugin mechanism"
  homepage "https://github.com/cloudwego/thriftgo"
  url "https://github.com/cloudwego/thriftgo/archive/refs/tags/v0.4.5.tar.gz"
  sha256 "8469be2df13bb1c2128a3594e4d59fb718ddf3da603181d163dbcf3d230214af"
  license "Apache-2.0"
  head "https://github.com/cloudwego/thriftgo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d21e7f4fcfe6e416ca12f60946f9fba844d3655c5f55ee74464a8d68df99b7c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d21e7f4fcfe6e416ca12f60946f9fba844d3655c5f55ee74464a8d68df99b7c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d21e7f4fcfe6e416ca12f60946f9fba844d3655c5f55ee74464a8d68df99b7c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "7479b1ff7069e364795aa5f94dfafb8ff5c36c57dbb27ddcc7052c5cb139b301"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c6aa972482bd6bac8b182a9eff23ab06000febb8eb3b5c4e0802aa49a9fcc22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "998dcd0021acb422ecd7baf840339121e0664e1ad490b451497045f8756deec9"
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
    assert_path_exists testpath/"api/test.go"
    refute_predicate (testpath/"api/test.go").size, :zero?
  end
end
