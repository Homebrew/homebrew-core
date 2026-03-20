class Sandvault < Formula
  desc "Run AI agents isolated in a sandboxed macOS user account"
  homepage "https://github.com/webcoyote/sandvault"
  url "https://github.com/webcoyote/sandvault/archive/refs/tags/v1.1.28.tar.gz"
  sha256 "3e26015807e2db8e0066205a08fb6858c0313d90899f9d0a1e0077af86f2a9d4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9fcd1025a0e4a5efe2221e4c202fa5d599b76a8072cbaa7966ddb13cc0b13ae0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9fcd1025a0e4a5efe2221e4c202fa5d599b76a8072cbaa7966ddb13cc0b13ae0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9fcd1025a0e4a5efe2221e4c202fa5d599b76a8072cbaa7966ddb13cc0b13ae0"
    sha256 cellar: :any_skip_relocation, sonoma:        "f920ded78b42c039052a58be3aee1eb74468fecf53c8cbeb83eaa1b1a7326375"
  end

  depends_on :macos

  conflicts_with "runit", because: "both install `sv` binaries"

  def install
    prefix.install "guest", "sv"
    bin.write_exec_script "#{prefix}/sv"
    guest_home_user.mkpath
    ln_sf guest_home_user, prefix/"guest/home/user"
  end

  def guest_home_user
    pkgetc/"guest_home_user"
  end

  def caveats
    <<~EOS
      sandvault's guest user home directory is #{guest_home_user}.
      These files will be copied to the sandvault home directory during setup or rebuild.
    EOS
  end

  test do
    assert_equal "sv version #{version}", shell_output("#{bin}/sv --version").chomp
  end
end
