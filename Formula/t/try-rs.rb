class TryRs < Formula
  desc "Temporary workspace manager for fast experimentation in the terminal"
  homepage "https://try-rs.org/"
  url "https://github.com/tassiovirginio/try-rs/archive/refs/tags/v1.7.17.tar.gz"
  sha256 "67574410ebbb1f6dd8a2cc7426c387d45df35da1df9670873ce999dc6f71315d"
  license "MIT"
  head "https://github.com/tassiovirginio/try-rs.git", branch: "main"

  bottle do
    manifest_sha256 "d15d2da9d94c71d8cddbc5ab3076df00e5a53d7afdae30a0d855bd85b01170e0"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "21f5d0e843540636cf34af7fd407ff70261cdd0780a1b76ed9a669178a76be42"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "75428bac1c20fdf948be7081ecb2832c315c6c5c389be73f1bef22e9fd470008"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8e4ee44f9e763790140c5ccf95f37e29a855a916e8c9dedd830232bced6c2b1e"
    sha256 cellar: :any,                 arm64_linux:       "ba6e426f83cccdca808dee69d0d232ddd6150011bd0cc3a240073dd083e8fc76"
    sha256 cellar: :any,                 x86_64_linux:      "1e89abed4268cc447c9db5ea2eeafeff10bce42c0eec345eb490ad79c332dd33"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/try-rs --version")
    assert_match "command try-rs", shell_output("#{bin}/try-rs --setup-stdout zsh")
  end
end
