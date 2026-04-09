class Tmex < Formula
  desc "Minimalist tmux layout manager"
  homepage "https://github.com/evnp/tmex"
  url "https://github.com/evnp/tmex/archive/refs/tags/v2.0.6.tar.gz"
  sha256 "83f16a8231c1c14105134c5e30d1294b41011de2e624e2a91f37d335b5a01712"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "7962a086b783ba9d0c735495c568e5a2299e8a33891772d70069dd68ea2d408f"
  end

  depends_on "tmux"

  uses_from_macos "bash"

  def install
    bin.install "tmex"
    man1.install "man/tmex.1"

    # Build an `:all` bottle
    inreplace man1/"tmex.1" do |s|
      s.gsub! "/opt/homebrew", HOMEBREW_PREFIX
      s.gsub! prefix, opt_prefix, audit_result: false
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tmex -v 2>&1")

    assert_match "new-session -s test", shell_output("#{bin}/tmex test -tp 1224")
  end
end
