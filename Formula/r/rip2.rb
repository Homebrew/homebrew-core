class Rip2 < Formula
  desc "Safe and ergonomic alternative to rm"
  homepage "https://github.com/MilesCranmer/rip2"
  url "https://github.com/MilesCranmer/rip2/archive/refs/tags/v0.9.4.tar.gz"
  sha256 "e6d3143958b838ebbf421fb933d8e46ecc28c8298f435bdf09f647b4def452f6"
  license "GPL-3.0-or-later"
  head "https://github.com/MilesCranmer/rip2.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ae3f478f94cdd1f8ee89a203e7512d8d3aa905ed3f3269d601c928043830386"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45581b64a085df4f559d5042f855fb06aa75f8fe81e4dc44433aa6c850dc3337"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f09b242e19dd0070ad027b4cc0adade3f0686f55c5cf3e236df7c1017acaa9d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "241fec9cb680a7f54f5de39370bff16932810c5dbbbadfdf6b582502ecf3eef9"
    sha256 cellar: :any_skip_relocation, ventura:       "77367b4f04e6b99826787e7c780288eb7964958bef28e3769be6941555897773"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f0aadb2f2e01fc633c9514cd812e03165c6bc0b1be630c934b5582cbf9e28513"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "263a41b50d75bfaa94c739dec7fd55cac5ee1e73c154e4c483e1913a3fa0fadc"
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
