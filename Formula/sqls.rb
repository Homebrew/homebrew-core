class Sqls < Formula
  desc "SQL language server written in Go"
  homepage "https://github.com/lighttiger2505/sqls"
  url "https://github.com/lighttiger2505/sqls/archive/refs/tags/v0.2.22.tar.gz"
  sha256 "0f417123331b23a50b10f2724befc53aa82f44150cf84f28bfb885f768697a01"
  license "MIT"
  head "https://github.com/lighttiger2505/sqls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "faf408ae757458bf1e26893201d6e900f05eca022fb1ee01559fa5a0f1d1622f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6dbca6e8e07e366b9926ddb5da7068e4aab06a8f44ac4c10e39a4cc956c823f3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3dea0bf951c056448af9f587db401b9aeaf8fb3def88ce54a5db05c3737cadae"
    sha256 cellar: :any_skip_relocation, ventura:        "fd2c24c485ca9676c83fb24b735961b6a1f7436e81818e558657e058fce4b3cf"
    sha256 cellar: :any_skip_relocation, monterey:       "7e0b61b52ec2b7f34122844099657f8be14a27af74509e7f7ecb59f9aad0f0a0"
    sha256 cellar: :any_skip_relocation, big_sur:        "facee7e345867ac52396628dd98093a326032cefe43f1e16ce91941665dd39bd"
    sha256 cellar: :any_skip_relocation, catalina:       "5ec498c6c475d39d5badcdc0a4e81c5a7f10d9c51c9d6019021754351ed26361"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5eb770bee66bb17bad1307ce42b6e4d1d90352612c28ffe832ba8eeae74dd271"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "processId":88075,
          "rootPath":"#{testpath}",
          "capabilities": {}
        }
      }
    JSON
    input = "Content-Length: #{json.size}\r\n\r\n#{json}"
    output = pipe_output("#{bin}/sqls", input, 0)
    assert_match(/^Content-Length: \d+/i, output)
  end
end
