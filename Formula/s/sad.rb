class Sad < Formula
  desc "CLI search and replace | Space Age seD"
  homepage "https://github.com/ms-jpq/sad"
  url "https://github.com/ms-jpq/sad/archive/refs/tags/v0.4.33.tar.gz"
  sha256 "ec2b533aaa6c39b4f87d6154854ead4fc381fc9fc9b727b2fc82e6ec4f7c1d8b"
  license "MIT"
  head "https://github.com/ms-jpq/sad.git", branch: "senpai"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "266c3d05de32deb24e9da7aed1e720552cadd447a773383e231d75b5966deabe"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f0b1348345d5d3c258a156446aeed754ce919928e2db7bbe669480395242719f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "92c50d3c1748622b63c9658c963d96574cb74cb27d771b7e58e916614b0fc962"
    sha256 cellar: :any,                 arm64_linux:       "8fb74eff87307ea87714a2d9f3fd4bbaa162ae6d4e48cae9218de486ab205d0c"
    sha256 cellar: :any,                 x86_64_linux:      "334f3df0c338027427787d7a45ca2fb86796937a132601468aab3d0cab591c69"
  end

  depends_on "rust" => :build

  uses_from_macos "python" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    test_file = testpath/"test.txt"
    test_file.write "a,b,c,d,e\n1,2,3,4,5\n"
    system "find #{testpath} -name 'test.txt' | #{bin}/sad -k 'a' 'test' > /dev/null"
    assert_equal "test,b,c,d,e\n1,2,3,4,5\n", test_file.read

    assert_match "sad #{version}", shell_output("#{bin}/sad --version")
  end
end
