class Skate < Formula
  desc "Personal key value store"
  homepage "https://github.com/charmbracelet/skate"
  url "https://github.com/charmbracelet/skate/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "98b60c6d78e89467f37d49aca532ba541201737d8824ad251f4fad274f9556e8"
  license "MIT"
  head "https://github.com/charmbracelet/skate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a9da5852f0acb70341c6833a32617133465b34318ea58484fdb4687118c4aa27"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a9da5852f0acb70341c6833a32617133465b34318ea58484fdb4687118c4aa27"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a9da5852f0acb70341c6833a32617133465b34318ea58484fdb4687118c4aa27"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c10586eb4bffafffee9f8a87fb1ca4a84961a5559abbf373c87951c886310eaf"
    sha256 cellar: :any,                 x86_64_linux:      "3a8f0ec7e337f5017a084021999b851a5703cf92ceeec886c8c183f65008141c"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    # fang only reads the version from Go module build info, which source builds lack
    inreplace "main.go", "rootCmd)", "rootCmd, fang.WithVersion(\"#{version}\"))"
    system "go", "build", *std_go_args

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
