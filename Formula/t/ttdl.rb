class Ttdl < Formula
  desc "Terminal Todo List Manager"
  homepage "https://github.com/VladimirMarkelov/ttdl"
  url "https://github.com/VladimirMarkelov/ttdl/archive/refs/tags/v6.2.3.tar.gz"
  sha256 "ca416e2bb76e4770e9d89a8dfffde723a5b0be78f70cf746e0a7ab368d933f89"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8d3c9ac866fc075b0ecfd48fc484643954ae9372a10983e3778334f865edd338"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e4835022d9d6a0916357df872b86204640bb4312ac80c734db14c0b5558f40ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1aad056613280e11f1f04b5c5afe5aeae85efb7413b123f5a8e121ba315322d4"
    sha256 cellar: :any,                 arm64_linux:       "f3679b4d1bed8f85f4f7b39d36141562c6f6b83a082fa0a4d1dcaeca9cedf945"
    sha256 cellar: :any,                 x86_64_linux:      "6d0d1318031e854e5cd2cbea18e249b5828107670c15c39be559a11ae73424c3"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Added todo", shell_output("#{bin}/ttdl 'add readme due:tomorrow'")
    assert_path_exists testpath/"todo.txt"
    assert_match "add readme", shell_output("#{bin}/ttdl list")
  end
end
