class Thriftgo < Formula
  desc "Implementation of thrift compiler in go language with plugin mechanism"
  homepage "https://github.com/cloudwego/thriftgo"
  url "https://github.com/cloudwego/thriftgo/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "1497fe41c38d8bd4386c9a0f23ae6a3b22e40b6e89bf99e4e8af8f6455b1cbfc"
  license "Apache-2.0"
  head "https://github.com/cloudwego/thriftgo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b7ee2ba1aa9f9690d6b5326f0e900c77a3b0adfdcc66521f5512df21b4f505a4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0fc56cb8026f94c9c649beec9558b53189034f09ee10a5066e5ca22f0b74a82e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "beaafab821b8a44a466611dda80445787f30a0bbe361d005ea8c79fbe6e3ace0"
    sha256 cellar: :any_skip_relocation, ventura:        "f18db41211d71f3c9a6c814e0ee377a005893d7cc9828fdbf3d76065cc667cf5"
    sha256 cellar: :any_skip_relocation, monterey:       "53b7557a2fcdd64754a957f134d2964622949c455ea5f639b462ef4c421bc735"
    sha256 cellar: :any_skip_relocation, big_sur:        "dd6889ced06deafca45449489509c8921fd062025b8bcc35310a00b08ab1de36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1569c530a94ceb6c958e985a431fa10a1c6be1916bc384d7c11d52aae72fedbd"
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
