class Zet < Formula
  desc "CLI utility to find the union, intersection, and set difference of files"
  homepage "https://github.com/yarrow/zet"
  url "https://github.com/yarrow/zet/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "678e569b4506c7099a4d99e75d420cf3b852ae3b5f19cd83e1a0d37be815a483"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "320335d05bb7addd47c1b8518ca9b66888df18229970dee69bf064e75105ded1"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "af692fa15c5337ac1a3b8e17b44ab6e18202726a6e5e4e2a74b33e9f5ea949d0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "010ab30280e99bc2fead6af0c98c14dd66c5739289f1dd2cfdf7460a55972cd1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ef37cf0298c109c40674c1a1f7a0946fe3f82303c1dd48a143fd561d9aebdaac"
    sha256 cellar: :any,                 arm64_linux:       "82edf325071c84a233285a3ab1ec0fd1ec29ae6575f1e5aeb4d9a1bf66a9f619"
    sha256 cellar: :any,                 x86_64_linux:      "4f08a7688d1271ae81ed2611f9cdc62780a385a5e6d8163a5d586f4bc164ffdf"
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
    (testpath/"foo.txt").write("1\n2\n3\n4\n5\n")
    (testpath/"bar.txt").write("1\n2\n4\n")
    assert_equal "3\n5\n", shell_output("#{bin}/zet diff foo.txt bar.txt")
  end
end
