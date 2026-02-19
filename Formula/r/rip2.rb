class Rip2 < Formula
  desc "Safe and ergonomic alternative to rm"
  homepage "https://github.com/MilesCranmer/rip2"
  url "https://github.com/MilesCranmer/rip2/archive/refs/tags/v0.9.6.tar.gz"
  sha256 "657ded2ee364e0d548697c0de28ae4e8d9564c0b5c63fd16b6718edba9a33554"
  license "GPL-3.0-or-later"
  head "https://github.com/MilesCranmer/rip2.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7a0e49f9192ce8230a4ed85ed3db21c92aa67a83528eed0cc7f84bf60972c6aa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eff959874609fee82ce0b0f3cf597cf5940ff57c293cad89d24889e8a17088f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bbb60b76782a258804c09b7367108f11de0f388bf9780c4278c9192bc383fdb6"
    sha256 cellar: :any_skip_relocation, sonoma:        "4604458cdf5d35b317fc845448ff700c39151f070f7503794a38969f54bc41b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ab9740bddaace23b393153f08988f7afccd60b67c3f81c5319b88acc55b4d24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a582694b6bcd21a59f5393e5d56b648b3c553d5be2e1b31b49106a099d970a2"
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
