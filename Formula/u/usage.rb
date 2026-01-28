class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://github.com/jdx/usage/archive/refs/tags/v2.15.1.tar.gz"
  sha256 "1ec54018b71af38c111dfe0d476a1be59235518afa26f591ac070afe093eb4fd"
  license "MIT"
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "db6a5aadd24220b1569fb6908b46dfd28c86ed500309ebfce05902d06588fbfb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a8b012645311c737c23c47c28ea22e01a15d2fd3f825eeadfa0b5bbd8f5c5cc9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82488fb6dee809c0f6aea5ec090a96a1a5aba5ea8b725af5cc81c8901aa76230"
    sha256 cellar: :any_skip_relocation, sonoma:        "a104951ccfc72c549c0a09c6d40ce0350f69cfd64b16aa3b185b2741a125b8f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a027218a61f422eeb5f3b24511d2855579bacb684efaaef9e9debb945d522630"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d651ff7d8e9a695597d92033c8acc1f4a16fc1262502a566bba96cd3c1d27c73"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
    man1.install "cli/assets/usage.1"
    generate_completions_from_executable(bin/"usage", "--completions")
  end

  test do
    assert_match "usage-cli", shell_output("#{bin}/usage --version").chomp
    assert_equal "--foo", shell_output("#{bin}/usage complete-word --spec 'flag \"--foo\"' -").chomp
  end
end
