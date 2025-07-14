class Thriftgo < Formula
  desc "Implementation of thrift compiler in go language with plugin mechanism"
  homepage "https://github.com/cloudwego/thriftgo"
  url "https://github.com/cloudwego/thriftgo/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "da9045011f581e7298b7ceadc87799da16f129dece7831134ef99686cabee997"
  license "Apache-2.0"
  head "https://github.com/cloudwego/thriftgo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c720ab9c1f830deec42fba0c376e3953a8ff3e5860a41c9d0268d2fdb4567eaa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c720ab9c1f830deec42fba0c376e3953a8ff3e5860a41c9d0268d2fdb4567eaa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c720ab9c1f830deec42fba0c376e3953a8ff3e5860a41c9d0268d2fdb4567eaa"
    sha256 cellar: :any_skip_relocation, sonoma:        "bbf29ea8be747f8fb6bcc955b9a410fd5338bcfd0f1e7b3d13961d0facee1d58"
    sha256 cellar: :any_skip_relocation, ventura:       "bbf29ea8be747f8fb6bcc955b9a410fd5338bcfd0f1e7b3d13961d0facee1d58"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84c521e4451829ce8f2c9bda42627067ff1424904ffb26d003999ba00635af3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "418202e1636b9ecf8d0703e3db623e3d1c55696f64e289bd01bd02ade6d6e032"
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
