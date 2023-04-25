class Thriftgo < Formula
  desc "Implementation of thrift compiler in go language with plugin mechanism"
  homepage "https://github.com/cloudwego/thriftgo"
  url "https://github.com/cloudwego/thriftgo/archive/refs/tags/v0.2.9.tar.gz"
  sha256 "d9b2c99f047a5ce98bec4effd8b8ae3e997a1522d745bfc188647a86ec8ed33f"
  license "Apache-2.0"
  head "https://github.com/cloudwego/thriftgo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a32c5a2b0338c47a94cffb02b1f07bded134bfe919ce4caef3303c003ff01065"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a32c5a2b0338c47a94cffb02b1f07bded134bfe919ce4caef3303c003ff01065"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a32c5a2b0338c47a94cffb02b1f07bded134bfe919ce4caef3303c003ff01065"
    sha256 cellar: :any_skip_relocation, ventura:        "b63b0642fff4e5a648011d202c40fbd980bab73a8b9a817e29f5b46537476fd6"
    sha256 cellar: :any_skip_relocation, monterey:       "b63b0642fff4e5a648011d202c40fbd980bab73a8b9a817e29f5b46537476fd6"
    sha256 cellar: :any_skip_relocation, big_sur:        "b63b0642fff4e5a648011d202c40fbd980bab73a8b9a817e29f5b46537476fd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89284f600e2384f1378c5c7a0fb33c7624b0bb95529ef0872f60115d75f7c644"
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
