class Thriftgo < Formula
  desc "Implementation of thrift compiler in go language with plugin mechanism"
  homepage "https://github.com/cloudwego/thriftgo"
  url "https://github.com/cloudwego/thriftgo/archive/refs/tags/v0.4.3.tar.gz"
  sha256 "d705854e766e8bc89e2ef44385d00810938fcba22686d417d93c8f83a07fe3ce"
  license "Apache-2.0"
  head "https://github.com/cloudwego/thriftgo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5cb46a98965f84e1857d0ae5395d532e3cbdef428e03e39a60ba40bf75fb48ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5cb46a98965f84e1857d0ae5395d532e3cbdef428e03e39a60ba40bf75fb48ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5cb46a98965f84e1857d0ae5395d532e3cbdef428e03e39a60ba40bf75fb48ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "132fa03cdcc0762f6df66d48116df589207f914fcdeb207e27ec8ae8852f0ab9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf9b14ced5844d920c396b4545bb0f41a9a065ced28314d3fc1f26b988a79df3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c769a0df181ec44dff7f01ce065f5f32370671d478626344fc615bb337bc099"
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
