class Sandvault < Formula
  desc "Run AI agents isolated in a sandboxed macOS user account"
  homepage "https://github.com/webcoyote/sandvault"
  url "https://github.com/webcoyote/sandvault/archive/refs/tags/v1.29.0.tar.gz"
  sha256 "4c3c36869c9fdaa50a33c9fb16303530e8bacdea6ad2166c6d69b327d80c8d1c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "66dba919a05b30025830d91df877751aa369bd8ad9d1b11f7f8a786595958a56"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66dba919a05b30025830d91df877751aa369bd8ad9d1b11f7f8a786595958a56"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66dba919a05b30025830d91df877751aa369bd8ad9d1b11f7f8a786595958a56"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd942205d7a8cb7c399592f1bc99865c216561361f83bc4d6fe345397b6a7f8e"
  end

  depends_on :macos

  conflicts_with "runit", because: "both install `sv` binaries"

  def install
    libexec.install "guest", "helpers", "skills", "sv", "sv-clone", "sv-agentsview-setup"
    bin.write_exec_script libexec/"sv", libexec/"sv-clone", libexec/"sv-agentsview-setup"
  end

  test do
    assert_equal "sv version #{version}", shell_output("#{bin}/sv --version").chomp
  end
end
