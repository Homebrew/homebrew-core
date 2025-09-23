class Sad < Formula
  desc "CLI search and replace | Space Age seD"
  homepage "https://github.com/ms-jpq/sad"
  url "https://github.com/ms-jpq/sad/archive/refs/tags/v0.4.32.tar.gz"
  sha256 "a67902b9edb287861668ee3e39482c17b41c60e244ece62b3f8016250286294f"
  license "MIT"
  head "https://github.com/ms-jpq/sad.git", branch: "senpai"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6a86363c4e34a7ef28f442c18631477562f6b2e53b528dca842d89a61f72aafb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc792df17bca12c265808a20efcbf4444fddf598e1b0671938f624d60a02f930"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "013696e18b0fd86010f790c555f8aa37c1f7058990fa4a4b2ceff65d17daaadc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "49df2026de6f61f870fc3c23d286214842af83b0bb92ea8e7f9a2e005e8b0d88"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac5f622402e313226339eb22f389fe826994ee8771b23cc28c2188ff81096f80"
    sha256 cellar: :any_skip_relocation, ventura:       "5afe1a5fac8625f958c34c4b7b030c4d4d6d3c3b7c7212988f19a8e7f6928f39"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "db2a7e7543515e39ad52ebe32ebd9821e3eec5e0cd1a3b0096342682de0a1536"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5eb56b7ce0c1cd515a1e2492614a4cbe2b3ea8e3652f0a9ad2a2ed43d9eec43b"
  end

  depends_on "rust" => :build

  uses_from_macos "python" => :build

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
