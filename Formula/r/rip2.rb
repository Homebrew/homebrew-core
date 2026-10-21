class Rip2 < Formula
  desc "Safe and ergonomic alternative to rm"
  homepage "https://github.com/MilesCranmer/rip2"
  url "https://github.com/MilesCranmer/rip2/archive/refs/tags/v0.9.7.tar.gz"
  sha256 "8f3dbd77775e4b632e99eff6cd3b0ac4e9f886d7e879d8648484cf3e7d0e0cee"
  license "GPL-3.0-or-later"
  head "https://github.com/MilesCranmer/rip2.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6f967fb6f3431a6c4ab981a44f2684b712001c63b5d653bbd19374b481da1ae6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "eb8162b1904822d5ba4ae34d49d9d8a2da2acdec0fc2251ce5c46012b772ad80"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fa8efa4b7b779fd88b61cfc77bf9d151bf045d04eb1f558523b73b10a7a6889a"
    sha256 cellar: :any,                 arm64_linux:       "3d45726bcf83c28ccc1ae2cbf4d0ce24885de05a296ace8207c8e3466dffbae4"
    sha256 cellar: :any,                 x86_64_linux:      "48edd668cb28e1477f327362a7b6cbf8bdf2a269ae60855349a50bc9fcd6f569"
  end

  depends_on "rust" => :build

  conflicts_with "rm-improved", because: "both install `rip` binaries"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"rip", "completions", shells: [:bash, :zsh, :fish, :pwsh])
    (share/"elvish/lib/rip.elv").write Utils.safe_popen_read(bin/"rip", "completions", "elvish")
    (share/"nu/completions/rip.nu").write Utils.safe_popen_read(bin/"rip", "completions", "nushell")
  end

  test do
    # Create a test file and verify rip can delete it
    test_file = testpath/"test.txt"
    touch test_file
    system bin/"rip", "--graveyard", testpath/"graveyard", test_file.to_s
    assert_path_exists testpath/"graveyard"
    refute_path_exists test_file
  end
end
