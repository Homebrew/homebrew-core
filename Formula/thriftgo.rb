class Thriftgo < Formula
  desc "Implementation of thrift compiler in go language with plugin mechanism"
  homepage "https://github.com/cloudwego/thriftgo"
  url "https://github.com/cloudwego/thriftgo/archive/refs/tags/v0.2.11.tar.gz"
  sha256 "e6c25ca6c405d475af4deb7e19358586d5c66c09f355d602eac7301e79052b85"
  license "Apache-2.0"
  head "https://github.com/cloudwego/thriftgo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b0a5111274c7dd35a06da67d6b13d82cc007176939c95d9c9fd70220fdc6ac7c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b0a5111274c7dd35a06da67d6b13d82cc007176939c95d9c9fd70220fdc6ac7c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b0a5111274c7dd35a06da67d6b13d82cc007176939c95d9c9fd70220fdc6ac7c"
    sha256 cellar: :any_skip_relocation, ventura:        "ee090440e841e632694c8dc8493abbec7b5436030f5aab8a71ed6e5bd987623b"
    sha256 cellar: :any_skip_relocation, monterey:       "ee090440e841e632694c8dc8493abbec7b5436030f5aab8a71ed6e5bd987623b"
    sha256 cellar: :any_skip_relocation, big_sur:        "ee090440e841e632694c8dc8493abbec7b5436030f5aab8a71ed6e5bd987623b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4904032dbb21c0ebeaa662e4f56ea2e6497ca7b5b4a95b637637a4b8fcd01ba1"
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
