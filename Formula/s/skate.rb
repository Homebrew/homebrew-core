class Skate < Formula
  desc "Personal key value store"
  homepage "https://github.com/charmbracelet/skate"
  url "https://github.com/charmbracelet/skate/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "f844fd980e1337be0f1bc321e58e48680fe3855e17c6c334ed8b22b9059949d2"
  license "MIT"
  head "https://github.com/charmbracelet/skate.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "966917f5054c2a722ce35156256437222602a118fa3a27a609c54397b7155730"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "966917f5054c2a722ce35156256437222602a118fa3a27a609c54397b7155730"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "966917f5054c2a722ce35156256437222602a118fa3a27a609c54397b7155730"
    sha256 cellar: :any_skip_relocation, sonoma:        "e28973a036de11d215bb911adf8708dd1e5d75071578bbc288c907c061cf23bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5d5dad73511d894bf5ef083edeb30eef46b13398fabf73b1f6d92e062644c9c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69757b83e851a3f06e7bd001afd3f27b813076f66c7b99c0ed84b6715daa1a3f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"skate", shell_parameter_format: :cobra)
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
