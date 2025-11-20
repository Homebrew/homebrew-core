class Tuios < Formula
  desc "Terminal UI OS (Terminal Multiplexer)"
  homepage "https://github.com/Gaurav-Gosain/tuios"
  url "https://github.com/Gaurav-Gosain/tuios/archive/refs/tags/v0.3.4.tar.gz"
  sha256 "5a6a60e54b0707046d91c9f71b3d2299d0d8fd332a86d40bbc39b755b4ea7ea2"
  license "MIT"
  head "https://github.com/Gaurav-Gosain/tuios.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "255c3c1eb3c5af245fef6af6aa5f522b087af67bb800ebea016791d7cd39a2a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a34779fa83528e6e3820b9f16f9be35962e176b807a88cefebb97843ff18b67a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b99c25a0182ddb3b1820f99c65f48e6cafbe5c4ce48377a591efd1759592f33f"
    sha256 cellar: :any_skip_relocation, sonoma:        "82902dd40e224b6312e73f14c81bb8f51ff1b95ed601d9abf033e9471c7291da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d789fdd728a5fbd5eb415a13946aff922cc81bb0a5b2de23227f0059081f6aa5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4412c0c53951a9e01939c85d9f25f10bcaf887621bc898600ce7aa19f3e9b85"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601} -X main.builtBy=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/tuios"

    generate_completions_from_executable(bin/"tuios", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tuios --version")

    assert_match "git_hub_dark", shell_output("#{bin}/tuios --list-themes")
  end
end
