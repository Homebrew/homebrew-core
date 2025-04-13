class Yazi < Formula
  desc "Blazing fast terminal file manager written in Rust, based on async I/O"
  homepage "https://github.com/sxyazi/yazi"
  url "https://github.com/sxyazi/yazi/archive/refs/tags/v25.4.8.tar.gz"
  sha256 "b001df58df5276587eecb89ed90e8ea7a2bf738819ccb1afc722355fa2c56eae"
  license "MIT"
  head "https://github.com/sxyazi/yazi.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56def0a10a0e7f1b4c1941e11ed57a6549097236d7170f89b95af6c5a30f083b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec4efda861b2dfd449f4fdc08c38c017fa5a2280f45139717099c4d6a73fe949"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2dca6fa933ce7c0fbc215f5c17d93956cf73a2f94241ae242b2ee1cf7ea876c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba844ddfeb33fd687d1267bdae049c487fd819c5fb686fa86c6fdfe60e5c2840"
    sha256 cellar: :any_skip_relocation, ventura:       "7df441bfdc05d77e593f517aa855b979976904419f8a84120ba92d82eaaa0fb6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "37803c653d1935f19ae80e29a15af58dcdbc584db6487d03b93c3621c373c6f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95a56eb8bb6c0e831dfca11df0f1da26f8d8fc4f4337f5c70cb36c46082c3654"
  end

  depends_on "rust" => :build

  def install
    ENV["VERGEN_GIT_SHA"] = tap.user
    ENV["YAZI_GEN_COMPLETIONS"] = "1"
    system "cargo", "install", *std_cargo_args(path: "yazi-fm")
    system "cargo", "install", *std_cargo_args(path: "yazi-cli")

    bash_completion.install "yazi-boot/completions/yazi.bash" => "yazi"
    zsh_completion.install "yazi-boot/completions/_yazi"
    fish_completion.install "yazi-boot/completions/yazi.fish"

    bash_completion.install "yazi-cli/completions/ya.bash" => "ya"
    zsh_completion.install "yazi-cli/completions/_ya"
    fish_completion.install "yazi-cli/completions/ya.fish"
  end

  test do
    # yazi is a GUI application
    assert_match "Yazi #{version}", shell_output("#{bin}/yazi --version").strip
  end
end
