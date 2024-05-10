class Thriftgo < Formula
  desc "Implementation of thrift compiler in go language with plugin mechanism"
  homepage "https://github.com/cloudwego/thriftgo"
  url "https://github.com/cloudwego/thriftgo/archive/refs/tags/v0.3.12.tar.gz"
  sha256 "09c93f538df89885b9649c1b186b2c2dab4900ac1b8789643de8e1166497756c"
  license "Apache-2.0"
  head "https://github.com/cloudwego/thriftgo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3590f2f03d87909e4a11e9f3b261b4959791b03082a7508d16ce786dbfdc1e85"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "53dca15c05fabd9d31ef859955970fa5668c1840e195ae2667f2e70b4a14ad61"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79c1dde505e49d71a653bb5e36db1c726d7a24d662fdcec682ce44096caebfb9"
    sha256 cellar: :any_skip_relocation, sonoma:         "ec13ec40064e5e888adf0972cc586a7e7a5bc46b008c0ae32dd513299e7a6476"
    sha256 cellar: :any_skip_relocation, ventura:        "3f7311767d62cf53640e29df20cc9c435303a13f286b9da48ed24a1d6316c9ea"
    sha256 cellar: :any_skip_relocation, monterey:       "4ef0a7938c0e429ed1033a0e1dc0538d22755ce3e90e8691a7591cf46fb4e78a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c997a72e9ea530ba898658a37cbecc8f1f83835560c313aebbe7bd2325bf612a"
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
