class TmuxSessionizer < Formula
  desc "Tool for opening git repositories as tmux sessions"
  homepage "https://github.com/jrmoulton/tmux-sessionizer/"
  url "https://github.com/jrmoulton/tmux-sessionizer/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "c3205764f70c8e7f94a1b32eccbc22e402cd9ab28c54d06b405073cae185bdd8"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ed8c2b2b44c4a59cd9bf195d3ad1acb7981e450fbe0261d4fe2902f5d103d1d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "99eee27a5e5b7e25cc15e3ca1cc68f502bf27331f5fa40f9a43a8f6298f8de60"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "304beda28af19425e12aa2913298f576cfda84026dfb76327d417dc361156d9f"
    sha256 cellar: :any_skip_relocation, sonoma:        "85cacea135842182e012520f4d85920105f85da0c63e3aa7b0d7d5b13fd0ccf5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c00fc1402d4707139bf7b6664d53526ef1654e13c650a7ab5208ad61b8c06c76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5aab4af1e5367b530e729a336708f7296265cfe6430e104324d87a24fbdb6c2"
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
    assert_match "Configuration has been stored", shell_output("#{bin}/tms config -p /dev/null")
    assert_match version.to_s, shell_output("#{bin}/tms --version")
  end
end
