class Starship < Formula
  desc "Cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v1.4.1.tar.gz"
  sha256 "3ba4e9935bfbb4c8b8fb18dcc73c0c9eda586a413b9d3f3378de4b095cb5f87a"
  license "ISC"
  head "https://github.com/starship/starship.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "91283d72f765b1feb142aba3b7d3bc56fa23efa9b32173e89505be7cbd004d99"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f151aa4da5ce2b4118071d7cc123b4f8be7df6adf78ecef46fd427b7a1fda868"
    sha256 cellar: :any_skip_relocation, monterey:       "74075d857c94fb65041dd9fba7343c6aaee04433369c40ca303ef8427db33bb7"
    sha256 cellar: :any_skip_relocation, big_sur:        "af14063369dafdfbfd90964cd2627c8cba5e99a9f9d3befc0dbfc4826c069666"
    sha256 cellar: :any_skip_relocation, catalina:       "5a32ab0df6a8032172f63cee2febcbceb8a2909d3c5f74141060aa77de37bef3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8946c9686beff3fa931fe631ef0d87847ed0a80d95cd0275c6c3cbf2d01fc32c"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "dbus"
  end

  def install
    system "cargo", "install", *std_cargo_args

    bash_output = Utils.safe_popen_read("#{bin}/starship", "completions", "bash")
    (bash_completion/"starship").write bash_output

    zsh_output = Utils.safe_popen_read("#{bin}/starship", "completions", "zsh")
    (zsh_completion/"_starship").write zsh_output

    fish_output = Utils.safe_popen_read("#{bin}/starship", "completions", "fish")
    (fish_completion/"starship.fish").write fish_output
  end

  test do
    ENV["STARSHIP_CONFIG"] = ""
    assert_equal "[1;32m❯[0m ", shell_output("#{bin}/starship module character")
  end
end
