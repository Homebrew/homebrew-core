class TmuxSessionizer < Formula
  desc "Tool for opening git repositories as tmux sessions"
  homepage "https://github.com/jrmoulton/tmux-sessionizer/"
  url "https://github.com/jrmoulton/tmux-sessionizer/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "186c83b892d29ea7161676c787589a2765c8550fe03d604eb44fd931df5e293c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "52fc5a69d6267f256d6224f386e2b1e21673695970783397c8b7651c4d4a3ff8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df1ee713aae26d6d8aba8d9d28acfb95fd3ba7b347b2a779174118cdbe4726dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf58c2687f60a767467deea5bd9ef5b21a5cd3ba8bbcc9ae9a8579b415aaf96a"
    sha256 cellar: :any_skip_relocation, sonoma:        "fba2821174c650778172f3e212b186fd78807ee016787df2ab3001db8812c529"
    sha256 cellar: :any,                 arm64_linux:   "efe76142e388c210962bf6e36dfaff4d7d1cf737b7126804a242d67bd8bd3537"
    sha256 cellar: :any,                 x86_64_linux:  "6800da10228fe8b4f72a3e6a58c3826602b73c18611a814fe8d92d678e7eb666"
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
