class Rip2 < Formula
  desc "Safe and ergonomic alternative to rm"
  homepage "https://github.com/MilesCranmer/rip2"
  url "https://github.com/MilesCranmer/rip2/archive/refs/tags/v0.9.5.tar.gz"
  sha256 "491bcf55246b0da4f03e1848c6532d85eaf680640db7f014454cb2092411c980"
  license "GPL-3.0-or-later"
  head "https://github.com/MilesCranmer/rip2.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "32cbd95f32c0d1df71b9c325f47597e77f55d7e0bdd8298f678e3429122d3365"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c9a788f7f8cdc9e5810214fc8caa8890ee1802e14fe9bef40914022acb1daaa2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af09c957a7fb215c1ac9f49c61d411649750f81cf1acaf7692013799ccf6f503"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a5ea06a6d273713bad688f3437d469881c60f0fff0548a04e08816cf8088e6ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "5623f6d35f35b801aca200e251fdbb8ed15737bce63d9e8522b58c1f04186c11"
    sha256 cellar: :any_skip_relocation, ventura:       "e5cf15ac04a340648e7279126aaec65535acaeafa7b29e24219ed4e4e27fbfb1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7033f640b903b2e46f988f9f7fd968c11e18c7f6f34a9ffbab629a1d639e0436"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9611cdaa697a6f46cda987142a90d485bb7d2feb266c08ed38503c84d6c5205"
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
