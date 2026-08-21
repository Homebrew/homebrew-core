class TmuxSessionizer < Formula
  desc "Tool for opening git repositories as tmux sessions"
  homepage "https://github.com/jrmoulton/tmux-sessionizer/"
  url "https://github.com/jrmoulton/tmux-sessionizer/archive/refs/tags/v0.6.1a.tar.gz"
  version "0.6.1a"
  sha256 "ce0a7756d2eb94d753cea5d4696e3683907d8d3237c2ac4e29cb91b0aa91b707"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "274c9a679489b35161ee3941b9935b3a414714d82571f22c2864ba9ae5e1c68c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "978c42dcc41dcc146049fd305e71926dd211f916301fdf41fc5225b64ca26c20"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4041f417a5c01d4687fa591a08ac81df5ce62708701d21dc15b1b91e87e5c3ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f9519b809040fed16f2e48ac98802d3061eae958fa5e426dcd0c2c94427a44c"
    sha256 cellar: :any,                 arm64_linux:   "16034716d0f178bb05a8697e26670433e84af7263b1c492c268c098378a2975d"
    sha256 cellar: :any,                 x86_64_linux:  "78dd2cfe831988bf321e0bebb93a95efa6d5df988ab01cb3e20633b8159cb6e9"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"tms", shell_parameter_format: :clap)
  end

  test do
    # TODO: recover version test in next release
    # assert_match version.to_s, shell_output("#{bin}/tms --version")

    assert_match "Configuration has been stored", shell_output("#{bin}/tms config -p /dev/null")
  end
end
