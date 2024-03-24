class Sad < Formula
  desc "CLI search and replace | Space Age seD"
  homepage "https://github.com/ms-jpq/sad"
  url "https://github.com/ms-jpq/sad/archive/refs/tags/v0.4.27.tar.gz"
  sha256 "4d1b9a006eed552283e4fc2ae229794ba013fbab910344a301cbac06cff45d1d"
  license "MIT"
  head "https://github.com/ms-jpq/sad.git", branch: "senpai"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "39d063216801c2fc39d81678bba8d3e6d581b189d0956f2afd6c0bab0cd986f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "14e19d72473391afd8be374d0a032c316235b067edc65a76745e32c5625e78ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "581065af75c51e405e6eea14a333fe5ccc22eaffdf1d09f137c3c1356ba0a31b"
    sha256 cellar: :any_skip_relocation, sonoma:         "4a42140db56e2b78b67b016bb3111ede9d12e779fadfdf0cebe67fa910254746"
    sha256 cellar: :any_skip_relocation, ventura:        "f0c74d5c5244cda2b3db55c4a8ae610b9d0b560660152c724932a5fc6658925f"
    sha256 cellar: :any_skip_relocation, monterey:       "184c1599b5c4664a49db0474f2867a0cdfea31335a3232e09490725e9fe8e003"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60f8d4eeba449a6dcd4ef6131563a2a6010ba5d9d5114af6ec50806a2e8d2706"
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
