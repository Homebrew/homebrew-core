class Risor < Formula
  desc "Fast and flexible scripting for Go developers and DevOps"
  homepage "https://risor.io/"
  url "https://github.com/risor-io/risor/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "d24f387a5e03a65a503632d1e7a874102e7f3331816e245d5fac9b4557d8c33b"
  license "Apache-2.0"
  head "https://github.com/risor-io/risor.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6531b4abc3b2a7f209dbb5f5e40062fbb0afe62a4f07567f42b783ff0c07e512"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fac4a685dbe80a2e883bb907dc2b36c6025a19e0999804c574a71ec81ed20739"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7466ee0c58b12d8ebb5e32d46b9bf8f7061fa165b399b6efb29e8ccf386e91a6"
    sha256 cellar: :any_skip_relocation, sonoma:         "7171a47ba6281252f2952b7990bfd2e51b3da687b9d2877e7728faec6c0eacb5"
    sha256 cellar: :any_skip_relocation, ventura:        "e3510618a85f3fa9b56eb568ad41ac36d994936ee643e517e98936f80d82d3fb"
    sha256 cellar: :any_skip_relocation, monterey:       "3055391d90fc0be77558a140e0cb40717ba85fd1657295cc667affc87894239b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba1b61561d60256714868dead5a4988e34bbef03711ce6cc48b5ff724daaea45"
  end

  depends_on "go" => :build

  def install
    chdir "cmd/risor" do
      ldflags = "-s -w -X 'main.version=#{version}' -X 'main.date=#{time.iso8601}'"
      system "go", "build", "-tags", "aws,k8s,vault", *std_go_args(ldflags:), "."
      generate_completions_from_executable(bin/"risor", "completion")
    end
  end

  test do
    output = shell_output("#{bin}/risor -c \"time.now()\"")
    assert_match(/\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}/, output)
    assert_match version.to_s, shell_output("#{bin}/risor version")
    assert_match "module(aws)", shell_output("#{bin}/risor -c aws")
    assert_match "module(k8s)", shell_output("#{bin}/risor -c k8s")
    assert_match "module(vault)", shell_output("#{bin}/risor -c vault")
  end
end
