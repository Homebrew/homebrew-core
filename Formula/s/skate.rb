class Skate < Formula
  desc "Personal key value store"
  homepage "https://github.com/charmbracelet/skate"
  url "https://github.com/charmbracelet/skate/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "09a29b9f10a3098780c397e89ff50578498abb2659b3d861ba90a9429f192970"
  license "MIT"
  head "https://github.com/charmbracelet/skate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "6901230e1a4ee9192e8a5c5e9fe3f068484f70f14fddc742742df51264ce45d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1426264ba44446dfecba6ce0b3343269f91c5cff428b1a0a10dffdd1a65b4a6f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1426264ba44446dfecba6ce0b3343269f91c5cff428b1a0a10dffdd1a65b4a6f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1426264ba44446dfecba6ce0b3343269f91c5cff428b1a0a10dffdd1a65b4a6f"
    sha256 cellar: :any_skip_relocation, sonoma:         "2cd214adbd53e8060bb6a2f9280038cab8fe49e8ed2515af4f7da458f6638b46"
    sha256 cellar: :any_skip_relocation, ventura:        "2cd214adbd53e8060bb6a2f9280038cab8fe49e8ed2515af4f7da458f6638b46"
    sha256 cellar: :any_skip_relocation, monterey:       "2cd214adbd53e8060bb6a2f9280038cab8fe49e8ed2515af4f7da458f6638b46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6142d5e5c0febdc7847e25fb4305d721c6c9c92f0562b3edc5b8fc1606887e2"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
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
