class Thriftgo < Formula
  desc "Implementation of thrift compiler in go language with plugin mechanism"
  homepage "https://github.com/cloudwego/thriftgo"
  url "https://github.com/cloudwego/thriftgo/archive/refs/tags/v0.3.17.tar.gz"
  sha256 "365bb6dfe2c8624b4ffb7c5f29d6664a6b04dd1a3e0ddc1fc171833ed4672e63"
  license "Apache-2.0"
  head "https://github.com/cloudwego/thriftgo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "6b92bb646e6edc259f08f2863737f63073db8290c8ae74d07c6cb697ce4479b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "396a4c20cff7bc0c44260ba79de851f88ccd90e9c35e99e5a6a17c26bc4fc2a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "396a4c20cff7bc0c44260ba79de851f88ccd90e9c35e99e5a6a17c26bc4fc2a1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "396a4c20cff7bc0c44260ba79de851f88ccd90e9c35e99e5a6a17c26bc4fc2a1"
    sha256 cellar: :any_skip_relocation, sonoma:         "1ba52cdaa13f40757173d816a04dbbd7c6c28629cd34c2b31aa5f27585e7f6c5"
    sha256 cellar: :any_skip_relocation, ventura:        "1ba52cdaa13f40757173d816a04dbbd7c6c28629cd34c2b31aa5f27585e7f6c5"
    sha256 cellar: :any_skip_relocation, monterey:       "1ba52cdaa13f40757173d816a04dbbd7c6c28629cd34c2b31aa5f27585e7f6c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c0d7536de1572d55d3554bbad20d42e6ef67979632dfab4d228b6dca67bb87a"
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
    system bin/"thriftgo", "-o=.", "-g=go", "test.thrift"
    assert_predicate testpath/"api"/"test.go", :exist?
    refute_predicate (testpath/"api"/"test.go").size, :zero?
  end
end
