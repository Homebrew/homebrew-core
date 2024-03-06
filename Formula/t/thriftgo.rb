class Thriftgo < Formula
  desc "Implementation of thrift compiler in go language with plugin mechanism"
  homepage "https://github.com/cloudwego/thriftgo"
  url "https://github.com/cloudwego/thriftgo/archive/refs/tags/v0.3.7.tar.gz"
  sha256 "97f475df09baf7fb3b7e7e187373cb26bd199f10c1b62e489002a3b0d334cdcf"
  license "Apache-2.0"
  head "https://github.com/cloudwego/thriftgo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "98311f1e693a1db95e4954b5ef0724dc75f69c4cc8b0a9005462ee42c3bc79f0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a167b217cd8183390ff6127a1a88ff4cf4ab29715996b62bf2378572e4a6541a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "22063d48e8e1b596eea6cedba45cee6290388d839c5a648887d1a856d32f67ae"
    sha256 cellar: :any_skip_relocation, sonoma:         "052c880eeeabe5c91de334aa7c85c4d98e8e587fe1d62617cc7c18503468e0f6"
    sha256 cellar: :any_skip_relocation, ventura:        "80bd3151a21b1913c3cc78fc44cb926fcfebb0ef4859d97a215d7f5269549bfd"
    sha256 cellar: :any_skip_relocation, monterey:       "8b19c1a000092452634c317a942d0111f5cf8205e1696fec8c00144ef2619386"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "254065dbfef2e84aa30f930337adf621d897b886611b2c3f55b987ed05cf82ae"
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
