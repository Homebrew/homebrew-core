class Thriftgo < Formula
  desc "Implementation of thrift compiler in go language with plugin mechanism"
  homepage "https://github.com/cloudwego/thriftgo"
  url "https://github.com/cloudwego/thriftgo/archive/refs/tags/v0.3.10.tar.gz"
  sha256 "9b9790799b5e22e8fc43b63886cbe2f0a2c8a8cfd734c696ec4239cfd0cfaa54"
  license "Apache-2.0"
  head "https://github.com/cloudwego/thriftgo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "369d2c6c67f96d821be105e4a81851dfdb9caa8d268e2f7502ab378353ca2297"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4680b240440aa2af9ba5088f923a184e25cf29b12ecfed4bcfe3f5f2aa233adc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4948d16981ce063a6a00757e179c0ac77b4f19096cce94870186e47b139560d5"
    sha256 cellar: :any_skip_relocation, sonoma:         "261b36a1ba781dc137afcfee532ecf9856aa53231375faea58abc3c411ef0a36"
    sha256 cellar: :any_skip_relocation, ventura:        "4a70c61bc09fae359f9fb7870e3e682463f0ff91c4f717f685ffd4b647fd6476"
    sha256 cellar: :any_skip_relocation, monterey:       "7a7b83fff5bcd668475b8661506d6fa88a59f63013a7cb8de5afd47e20012d3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f32ddddd240d38ec343a817c26b33662342ed8dc8192b45c4882cf7c573a08f7"
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
