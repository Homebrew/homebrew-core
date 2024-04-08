class Thriftgo < Formula
  desc "Implementation of thrift compiler in go language with plugin mechanism"
  homepage "https://github.com/cloudwego/thriftgo"
  url "https://github.com/cloudwego/thriftgo/archive/refs/tags/v0.3.9.tar.gz"
  sha256 "b0eace7a8f4ea2c8fc3e2548ae82bdd32c96c06e6b14e2063c5fe8f2cf0d4075"
  license "Apache-2.0"
  head "https://github.com/cloudwego/thriftgo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "11256979da2ebe8a7be0ce1a7f6ba74fb68a12369a36c41b2007999c5d5255a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae98aa803470a0f4acecc0f985dd96e4e3b4f3e432abea0abd6e9e1df8b13f22"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b3a39766ca7aaf1f7054269dcd87913afcbe4b874d2ce5a30971b6739c06ae3"
    sha256 cellar: :any_skip_relocation, sonoma:         "b150c67257a39dbb7f20052112b49718417f014259880c732c9c5395524fe236"
    sha256 cellar: :any_skip_relocation, ventura:        "2451d396ad82053d113bd2d673be576f5e8f0345b0d5df73a59fb23753ac290d"
    sha256 cellar: :any_skip_relocation, monterey:       "87cc3054383076d92ed9525aa1d8c53c1d8ba8d0675d3fc633928cb6c545d33f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3417e9c48b4ab5d1deffde96664ca9b5eaffaf32c003b05ed83f0cd40d34f1eb"
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
