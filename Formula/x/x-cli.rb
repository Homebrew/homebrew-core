class XCli < Formula
  desc "Command-line power tool for Twitter"
  homepage "https://github.com/sferik/x-cli"
  url "https://github.com/sferik/x-cli/archive/refs/tags/v5.0.0.tar.gz"
  sha256 "30685de7d87d385a1c74b6ef47732c8b5259fe50f434efd651757e5529cc2fe9"
  license "MIT"
  head "https://github.com/sferik/x-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "56f1bc8609a45e0aa452a222e42fd75477401c7755fb7afb13b31cc8c879ad94"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56122478d0233793ee93dc4c8bf813320bda3c4fb281af52bf32e94a82f9f8a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "02cdb7be7f6f6088afd1ed39a175162941628df746f35910d77812eea820ef32"
    sha256 cellar: :any_skip_relocation, sonoma:        "7597be285be23fa533a0aba4312dd578947ceebea1bf3b0420030da0b1aa3d4d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "130027094f9f3cc804d9c67750641d76016cb2f5ffca3cff890610df6d7827c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f17521c54fe762cf8863f1af94842cce12ecb382e7496fafb82e07805f8e6143"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_macos do
    conflicts_with "xorg-server", because: "both provide an `x` binary"
  end

  on_linux do
    depends_on "openssl@3"
  end

  def install
    # https://github.com/sferik/x-cli/issues/475
    inreplace "Cargo.toml", 'version = "6.0.0"', 'version = "5.0.0"'

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/x --version")
    assert_match "No active credentials found in profile", shell_output("#{bin}/x whoami 2>&1", 1)
  end
end
