class Witr < Formula
  desc "Why is this running?"
  homepage "https://github.com/pranshuparmar/witr"
  url "https://github.com/pranshuparmar/witr/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "af94fe23b01f4b7c672278228efb4a2df622170e0a4ef0e475be337bad11146a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "25a44348321deb322f0a635a97f9541df94715b30ad61b47bd7d01e9f5ff4025"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7607bec17e004824e0e60f88749b11141705e0199623ba4c490ae176aa9b809"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8eb5606fb748f5202c34f764e494317c4aee807a768635e6ebf90b6d404838d"
    sha256 cellar: :any_skip_relocation, sonoma:        "d1592640d1c113db271f49fb3944f69a58e5bd3ac0c7d66ebd4719a3c995ad85"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f04af41079deedd3cb68591650a91b624b13546c04c6eec10585dad050dbf404"
    sha256 cellar: :any,                 x86_64_linux:  "7347830a9d5a234026f79ae7e13ef46254c8dd5b4a3223948708899a04ad52cf"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.buildDate=#{time.iso8601}"), "./cmd/witr"
    generate_completions_from_executable(bin/"witr", "completion")
    man1.install "docs/cli/witr.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/witr --version")
    assert_match "no process ancestry found", shell_output("#{bin}/witr --pid 99999999 2>&1", 2)
  end
end
