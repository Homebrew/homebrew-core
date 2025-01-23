class Skate < Formula
  desc "Personal key value store"
  homepage "https://github.com/charmbracelet/skate"
  url "https://github.com/charmbracelet/skate/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "09a29b9f10a3098780c397e89ff50578498abb2659b3d861ba90a9429f192970"
  license "MIT"
  head "https://github.com/charmbracelet/skate.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f44627754bdf718f9e9dcb792a9fb17e71a3bf5f572051ccbfc6c58c5034cd8d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f44627754bdf718f9e9dcb792a9fb17e71a3bf5f572051ccbfc6c58c5034cd8d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f44627754bdf718f9e9dcb792a9fb17e71a3bf5f572051ccbfc6c58c5034cd8d"
    sha256 cellar: :any_skip_relocation, sonoma:        "0143bd4b5134b89dd110fcc8a7486aa9b59b212fed966787dc4daaab1e757ab7"
    sha256 cellar: :any_skip_relocation, ventura:       "0143bd4b5134b89dd110fcc8a7486aa9b59b212fed966787dc4daaab1e757ab7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17f8a89cbcbcf6016b838293c4ce88b91e2f9d63c3565c0fd86276075fcaeaf3"
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
