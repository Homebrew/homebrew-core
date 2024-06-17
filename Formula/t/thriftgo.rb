class Thriftgo < Formula
  desc "Implementation of thrift compiler in go language with plugin mechanism"
  homepage "https://github.com/cloudwego/thriftgo"
  url "https://github.com/cloudwego/thriftgo/archive/refs/tags/v0.3.13.tar.gz"
  sha256 "b1012a87d81433eb11eced4a9a1488d8a2311a02be497d701d820b3239a7449c"
  license "Apache-2.0"
  head "https://github.com/cloudwego/thriftgo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1856857ca793bc1c3e316f456de217b5993b9b126a45789777bddc72148a8014"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6d0f79962b35f12fbf044a76e1f7c145a0ca4c77c83824dcdc1f59f80cfa51bd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fbb43e6a5b85e4253fe17c4a3b7f76908584064d2a86c25c47b84d438806f4fd"
    sha256 cellar: :any_skip_relocation, sonoma:         "e90d8f55a87d416810f9103a76c2546b77a850309d08348b5c6473cd16186d78"
    sha256 cellar: :any_skip_relocation, ventura:        "ee89541ae676a3996ad80333e78e985ac1495a8468ce131891f44fd70c7fa52e"
    sha256 cellar: :any_skip_relocation, monterey:       "422ce0fc8b1922610bbb5972f36b49b4bf6a6532ef482d5c8e5be07198c27ea6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8dee8c8767fef8f4b005fb8d22f682fd13a24aeea96cd21ea15ec97f7fef7c45"
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
