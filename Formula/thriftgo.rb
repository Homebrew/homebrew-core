class Thriftgo < Formula
  desc "Implementation of thrift compiler in go language with plugin mechanism"
  homepage "https://github.com/cloudwego/thriftgo"
  url "https://github.com/cloudwego/thriftgo/archive/refs/tags/v0.2.12.tar.gz"
  sha256 "57e29bd899e57b02850ed074517ba9ed3f83c4d27b6bc78562273343cc9cae85"
  license "Apache-2.0"
  head "https://github.com/cloudwego/thriftgo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa412616d56ac57edf70d10e9756c847da10df0548e0ea2f54f02680283db403"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa412616d56ac57edf70d10e9756c847da10df0548e0ea2f54f02680283db403"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fa412616d56ac57edf70d10e9756c847da10df0548e0ea2f54f02680283db403"
    sha256 cellar: :any_skip_relocation, ventura:        "5eb4908efadd467bcb5b334f2dee8f5e5e78a11ba5ab1971c34f8ade0d596e70"
    sha256 cellar: :any_skip_relocation, monterey:       "5eb4908efadd467bcb5b334f2dee8f5e5e78a11ba5ab1971c34f8ade0d596e70"
    sha256 cellar: :any_skip_relocation, big_sur:        "5eb4908efadd467bcb5b334f2dee8f5e5e78a11ba5ab1971c34f8ade0d596e70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8c72d0d642ec8a23eb608fd8e1725f09f6a9bbb120e4772019a2fdc86134cef"
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
