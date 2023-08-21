class Thriftgo < Formula
  desc "Implementation of thrift compiler in go language with plugin mechanism"
  homepage "https://github.com/cloudwego/thriftgo"
  url "https://github.com/cloudwego/thriftgo/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "8fe3b263dc53f8bd3db0c643cca82aeba5f40a855c88478c1b1649ce68e34c44"
  license "Apache-2.0"
  head "https://github.com/cloudwego/thriftgo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b8d50e7676ddef2495915b4a05d5ad789520ed1158e706180f02e9a2dd55ff5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "63891dd2b965b141812111db7a6b54c349ae9faf3a97d70addfff1141a5ff593"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "95017b70d440e1a6b39f2e92a46749b22781844c3aee4bb9cc8785c34703c5e5"
    sha256 cellar: :any_skip_relocation, ventura:        "39c3284d7060e7bbfb2e1e256bc0bc927d81daed378532cab57640592dc7ea96"
    sha256 cellar: :any_skip_relocation, monterey:       "24641b93c773d1ef67889dc51c372768b239d38199925e292bdd3d672802ffb6"
    sha256 cellar: :any_skip_relocation, big_sur:        "0745d47dc7d4d3aa4f85c4c3322c95cd67f71c70948da30634368db02ee866f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2307698e8d8cb130e9af415780322b18e8e3ccb3293ac794f6aa83ab423854f"
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
