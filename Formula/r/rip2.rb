class Rip2 < Formula
  desc "Safe and ergonomic alternative to rm"
  homepage "https://github.com/MilesCranmer/rip2"
  url "https://github.com/MilesCranmer/rip2/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "1a2c54f04f5045de48553d4a81c359f3d5e0ed9ef6aa875185f43765533d2f15"
  license "GPL-3.0-or-later"
  head "https://github.com/MilesCranmer/rip2.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea0c7eb215c784b065efb7e46db7f7c75ca7fb61bc98969455462af6190092ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44468fe72c4039733863d730740f4bf40ad7727109629bedf75be6eec0027cdb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "39fb078c6a2e13c76e06dfb7469b96d6feb53e1164249eb4a1b6ad299e091534"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c5d8da937b1c88e6a448556aed6046d992db297028f540b1f72529f8f319010"
    sha256 cellar: :any_skip_relocation, ventura:       "7d6c2517e8bf095e38bffe709adbec3a6599a3dda0fe58ee0051f11b5d2fedb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33f7a2145695d4071889cef3610b7e38e565bf0077564be8203ecea01a1747a9"
  end

  depends_on "rust" => :build

  conflicts_with "rm-improved", because: "both install `rip` binaries"

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"rip", "completions", base_name: "rip")
    (share/"elvish/lib/rip.elv").write Utils.safe_popen_read(bin/"rip", "completions", "elvish")
    (share/"powershell/completions/_rip.ps1").write Utils.safe_popen_read(bin/"rip", "completions", "powershell")
    (share/"nu/completions/rip.nu").write Utils.safe_popen_read(bin/"rip", "completions", "nushell")
  end

  test do
    # Create a test file and verify rip can delete it
    test_file = testpath/"test.txt"
    touch test_file
    system bin/"rip", "--graveyard", testpath/"graveyard", test_file.to_s
    assert_predicate testpath/"graveyard", :exist?
    refute_predicate test_file, :exist?
  end
end
