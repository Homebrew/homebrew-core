class TryRs < Formula
  desc "Temporary workspace manager for fast experimentation in the terminal"
  homepage "https://try-rs.org/"
  url "https://github.com/tassiovirginio/try-rs/archive/refs/tags/v1.6.3.tar.gz"
  sha256 "6cafac8b9c719a35030e29421ad3c6bad8d5f1d20f131af5d7cb54479909a8ea"
  license "MIT"
  head "https://github.com/tassiovirginio/try-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4d0b85180403924b41cc2266b849ba283b2df5b0e70eab57e3fca64a95a3c43b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2829f4af7112b2529fe44529a0ada0e6f32c225689d537a8b0e7a9a32fdf1ef0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec9d54c4b84e2e20e490ad8588c07f8a0e7abb7d8179cb261447d9b1237cbe8a"
    sha256 cellar: :any_skip_relocation, sonoma:        "2cb9ffcb1a60a33a9e08423b976decfcb983f41a77c4e335f3553cd2b1b09979"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "031790db1c05cb49c7f837fe941613f7f18bce9833e3bfb3997b1651f89d7435"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "208fc72924ca069e788c9f74c9fbeb7fc84611d54c2f2a4c5143977c479c4d42"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/try-rs --version")
    assert_match "command try-rs", shell_output("#{bin}/try-rs --setup-stdout zsh")
  end
end
