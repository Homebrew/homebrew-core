class Thriftgo < Formula
  desc "Implementation of thrift compiler in go language with plugin mechanism"
  homepage "https://github.com/cloudwego/thriftgo"
  url "https://github.com/cloudwego/thriftgo/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "b6a1555e5fb0264075231ff72babe5c28ccfb1893aec4dd26baf9a0e8fc1908f"
  license "Apache-2.0"
  head "https://github.com/cloudwego/thriftgo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53f3fbca6aa77b1b588d06197096cfea7ba232bb3b1e2cabb0b9b390e16e93a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53f3fbca6aa77b1b588d06197096cfea7ba232bb3b1e2cabb0b9b390e16e93a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "53f3fbca6aa77b1b588d06197096cfea7ba232bb3b1e2cabb0b9b390e16e93a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "8837a082a7a66b5f89a4f707077cf73c278d84a41f6c4ec6d001059885b272ce"
    sha256 cellar: :any_skip_relocation, ventura:       "8837a082a7a66b5f89a4f707077cf73c278d84a41f6c4ec6d001059885b272ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6fbae7d271c1b3f8435066c5b35b9efb82ac79439ba7ebddb805953c8ff54ab4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "887cf03d5742f5eb02c9e8dabaeb50dcc22b44f4e580f6a61422d5223b276c00"
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
    assert_path_exists testpath/"api"/"test.go"
    refute_predicate (testpath/"api"/"test.go").size, :zero?
  end
end
