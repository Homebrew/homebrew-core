class Risor < Formula
  desc "Fast and flexible scripting for Go developers and DevOps"
  homepage "https://risor.io/"
  url "https://github.com/risor-io/risor/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "249c2f735290b44c02f64d9865b740f9a58d26833ef3fe175792932d758c3ca8"
  license "Apache-2.0"
  head "https://github.com/risor-io/risor.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4f241407bc2dfca70039654006c20bcbda13db7119eee3803451d7d3738ce6a5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eff741b006bebc17ff3cf7a2501f1fe8718d8e5c2a3206501cbf030158642b5e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "47ff257b101eb1870b6f6667f52917e653549db1f93a8d6039b3996c343799fe"
    sha256 cellar: :any_skip_relocation, ventura:        "135bf3c957ea66cd44d4ec1024d694b15e5d3dbc39aa84dd00818a4fec5b6ac3"
    sha256 cellar: :any_skip_relocation, monterey:       "4ba3e827bff5ae7ba0d7f676f5a1303c4bb281aa7dd9e88fe3d10378b114435e"
    sha256 cellar: :any_skip_relocation, big_sur:        "ef3a29491b6c067cf28d7e41eb42024302d22edc9d4c9e2640b84b0207b73a66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30c9a1e363372a01443ebde7f5bd90746d9767a8da47ecca3461ab1fd8b4cc3e"
  end

  depends_on "go" => :build

  def install
    chdir "cmd/risor" do
      ldflags = "-X main.version=#{version} -X main.date=#{time.iso8601}"
      system "go", "build", "-tags", "aws", *std_go_args(ldflags: ldflags), "."
      generate_completions_from_executable(bin/"risor", "completion")
    end
  end

  test do
    output = shell_output("#{bin}/risor -c \"time.now()\"")
    assert_match(/\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}/, output)
    assert_match version.to_s, shell_output("#{bin}/risor version")
    assert_match "module(aws)", shell_output("#{bin}/risor -c aws")
  end
end
