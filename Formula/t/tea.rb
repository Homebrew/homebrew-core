class Tea < Formula
  desc "Command-line tool to interact with Gitea servers"
  homepage "https://gitea.com/gitea/tea"
  url "https://gitea.com/gitea/tea/archive/v0.14.0.tar.gz"
  sha256 "f509de217ac0e57491ffdab2750516e8c505780881529ee703b9d0c86cc652a3"
  license "MIT"
  head "https://gitea.com/gitea/tea.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b63674ef2f7142e729556b558a60f92af60396a4bb1de10287d43cd52e4db288"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b63674ef2f7142e729556b558a60f92af60396a4bb1de10287d43cd52e4db288"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b63674ef2f7142e729556b558a60f92af60396a4bb1de10287d43cd52e4db288"
    sha256 cellar: :any_skip_relocation, sonoma:        "35ab819488018e4db984575cff64f38089fd42d8f6dad4283294517e194511ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e48ca1db82bfe7457a6b4c799abfec2de4cef3bbb4b31c8f81b5a4df0626e8ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad16e27854c16811967742d4b0d1baea0aa159dd4d79ee5be21c91c951c32550"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")
    generate_completions_from_executable(bin/"tea", "completion")
  end

  test do
    assert_match "no gitea login configured.", shell_output("#{bin}/tea pulls 2>&1", 1)
  end
end
