class Risor < Formula
  desc "Fast and flexible scripting for Go developers and DevOps"
  homepage "https://risor.io/"
  url "https://github.com/risor-io/risor/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "dbe5073663e36113232401a92ef10d20db1494d212a6f2ded812ff54837246b4"
  license "Apache-2.0"
  head "https://github.com/risor-io/risor.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d26fed1d1e7b1b46234cfb7732d59daba8d3969a6633a7331d88f8d64c8f04e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b410853af7379d55ae5935651bb1bd8f51b71fbe84d8ca146d4735f513e3c56c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "604050255b26bf7417be3c29c7428df59b850ad3c3bbea7cabf262c06f57a562"
    sha256 cellar: :any_skip_relocation, sonoma:         "846f2d493969fe2536152b80860f9237b2d0e2828ea4548e44c4f90e70d8e999"
    sha256 cellar: :any_skip_relocation, ventura:        "0c016cc389d9ffe2d591c5d9d2668401091fc632224b0fc05a14f3e6f21d03e7"
    sha256 cellar: :any_skip_relocation, monterey:       "f1137f689e7613b9c022d696fb1d8b02c2ac075dd839d79f95e842016982dd2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c21340532d926615e20a0e6a1c0697668623300f488e3a713ed727e38fc9aac"
  end

  depends_on "go" => :build

  def install
    chdir "cmd/risor" do
      ldflags = "-s -w -X 'main.version=#{version}' -X 'main.date=#{time.iso8601}'"
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
