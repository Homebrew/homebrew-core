class Thriftgo < Formula
  desc "Implementation of thrift compiler in go language with plugin mechanism"
  homepage "https://github.com/cloudwego/thriftgo"
  url "https://github.com/cloudwego/thriftgo/archive/refs/tags/v0.3.15.tar.gz"
  sha256 "c5660d7a8b38c566a692b897077d913b43ba805d761619e801100ec22b93b347"
  license "Apache-2.0"
  head "https://github.com/cloudwego/thriftgo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7a6bdfcc6b6c6e21bbc848ed7535eb2307dcace6dcc5cbca32c2858f8ec51829"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "14c720bd265968d3c3e6de490c59be11f88e5b39b2ecfefcb174f7dab6c3d7ee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95c92f86fe8ab7022c314805da91513242c81107e28676ee6b297e61c04df119"
    sha256 cellar: :any_skip_relocation, sonoma:         "f37bcceae21d2e42701fc2908842b181767bc40e6bc55a950179a9547e7762fd"
    sha256 cellar: :any_skip_relocation, ventura:        "e78d53082cec8758ad23517aaa56534547a236e15046acd37e3142f4945caedf"
    sha256 cellar: :any_skip_relocation, monterey:       "1621cded2297a198e0f06dde31446a9d53364909f2529b3054bc185e85ca52ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b35d4c48513ae9a3ed4a672de4e608a16d69cf810e8bf0544ab695279b44cf8d"
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
