class Witr < Formula
  desc "Why is this running?"
  homepage "https://github.com/pranshuparmar/witr"
  url "https://github.com/pranshuparmar/witr/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "3e28aa5082b7e83e35e2e8d2b0be30732ac454ac261eb8f315ae8eb30810e6a5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bd9fb425255725c69d39ae9ebe18c8cf4fb7fb6865d2ab2b05477304ccf58e57"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c187bae9ee368e0f0448483c19594ab7cfd95aecf4d09a48d68afa36089a11e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75788a7b721b2c21fe3f5095a78e0ad3941b895993f55119c854a7a00499fbcb"
    sha256 cellar: :any_skip_relocation, sonoma:        "18ab2624efe88e35a2099f3fd4e6bc86730b45fd0306b61db7b6ecbcd047349e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "279c926500ae3fade5ff2f858ea7fcf395093f142f1a7777db5e87fb1d7bc25c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6bcda88507cd3bafcdee588c8fac8f6459a38beeb40cd8825ecdf750ee9c77fb"
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
