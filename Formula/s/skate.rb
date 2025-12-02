class Skate < Formula
  desc "Personal key value store"
  homepage "https://github.com/charmbracelet/skate"
  url "https://github.com/charmbracelet/skate/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "f844fd980e1337be0f1bc321e58e48680fe3855e17c6c334ed8b22b9059949d2"
  license "MIT"
  head "https://github.com/charmbracelet/skate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dd5a8f8f84a8edcb61c40733fbef18e4369af5ee7fd8c106d0dcdce1f5cc798b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51dffe30dad6853d764248411bd1b373e56795410d7480ffcee819a67cf5b641"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51dffe30dad6853d764248411bd1b373e56795410d7480ffcee819a67cf5b641"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "51dffe30dad6853d764248411bd1b373e56795410d7480ffcee819a67cf5b641"
    sha256 cellar: :any_skip_relocation, sonoma:        "873150989401c84050ba2180e0edc835fd0daf05481d723626457ee6a7ff40cb"
    sha256 cellar: :any_skip_relocation, ventura:       "873150989401c84050ba2180e0edc835fd0daf05481d723626457ee6a7ff40cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d14356cf95cc1e3ccfbe9fc80ea1982f615afee372c2392149ee64ef5fe6fb8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "698c00996b38d34b04b8adadba65ffc338f77ac2f58889a31721f3b54d2e4fff"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"skate", "completion")
  end

  test do
    system bin/"skate", "set", "foo", "bar"
    assert_equal "bar", shell_output("#{bin}/skate get foo").chomp
    assert_match "foo", shell_output("#{bin}/skate list")

    # test unicode
    system bin/"skate", "set", "猫咪", "喵"
    assert_equal "喵", shell_output("#{bin}/skate get 猫咪").chomp

    assert_match version.to_s, shell_output("#{bin}/skate --version")
  end
end
