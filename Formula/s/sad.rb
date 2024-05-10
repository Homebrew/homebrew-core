class Sad < Formula
  desc "CLI search and replace | Space Age seD"
  homepage "https://github.com/ms-jpq/sad"
  url "https://github.com/ms-jpq/sad/archive/refs/tags/v0.4.28.tar.gz"
  sha256 "efda19aecec408095bb515975a1a6ed9e66d0ab985c2b580087b031261f71cfc"
  license "MIT"
  head "https://github.com/ms-jpq/sad.git", branch: "senpai"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dbd6742f7ca10b7a35934d48c97c15191b2a3a2838a8555dda14d49109135ec2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ca01f710469f4d9bc707800122a780bea33bf65b8c0905b6b20b07d9da4e7ee4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "389062b6527626a595b9eca5fff77226f83946174cf1e8e8763fba2f0e19103e"
    sha256 cellar: :any_skip_relocation, sonoma:         "4688e0e640f04662017f5578f1c70e3cfe7b1f63022ce380a095887edf3445cd"
    sha256 cellar: :any_skip_relocation, ventura:        "3bd4b813859fcf59ff862d243d6258b466898ef8e321b2c13df38cefc8d748c9"
    sha256 cellar: :any_skip_relocation, monterey:       "5b68be7a2dbd1faca977892f165ab7741a683ef1e69e163ddf11c365e805b0c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab533cf53f9716e0a690e92245ac96fb45ad6db60f11a8e2d6787b8a0e744284"
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
