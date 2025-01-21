class Rip2 < Formula
  desc "Safe and ergonomic alternative to rm"
  homepage "https://github.com/MilesCranmer/rip2"
  url "https://github.com/MilesCranmer/rip2/archive/refs/tags/v0.9.3.tar.gz"
  sha256 "466d2931c6437669d36326bbc9e0532c5b99fbf262e3b409adfbbdae3c7971f9"
  license "GPL-3.0-or-later"
  head "https://github.com/MilesCranmer/rip2.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf41290f72f70d1d544228e660775af17a874bf3b3249d943f9bfb57b43be442"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0090b45a09d7667566f943a717f6d4e174f3c7a7c3dd5fd0338a5d70bce4c7b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "49bcad0e10c35b8401e9d080c7712e43277a2abcad0aa493c3a9543e0ba6d541"
    sha256 cellar: :any_skip_relocation, sonoma:        "d0a292edee55b86824e46e4b5bb9456d2e933816cfa0555c9041dc605cb81831"
    sha256 cellar: :any_skip_relocation, ventura:       "e697e03669bd5cdcf5f6a5387d30e14f29c1582d92d5ccca0e4bca3469270a43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b36dad8b5a13e3ffc0147de907ae435ce6ee3dc6cad6009947174682602f0df"
  end

  depends_on "rust" => :build

  conflicts_with "rm-improved", because: "both install `rip` binaries"

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"rip", "completions")
    (share/"elvish/lib/rip.elv").write Utils.safe_popen_read(bin/"rip", "completions", "elvish")
    (share/"powershell/completions/_rip.ps1").write Utils.safe_popen_read(bin/"rip", "completions", "powershell")
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
