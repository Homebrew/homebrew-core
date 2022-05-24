class Saltwater < Formula
  desc "C compiler written in Rust, with a focus on good error messages"
  homepage "https://github.com/jyn514/saltwater"
  url "https://github.com/jyn514/saltwater/archive/0.11.0.tar.gz"
  sha256 "a9fedbb53586e045798ba26295b4da28157e4eb9945b5a74bbdaebca830f1316"
  license "BSD-3-Clause"
  head "https://github.com/jyn514/saltwater.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, monterey:     "dc1395bf530b4ea186fe898fc7aa8305c2392fc11dcda12c36b906d21721380a"
    sha256 cellar: :any_skip_relocation, big_sur:      "3ce720ef4e471ca3cf3b0f3bc9dbb4cf8988eeae18d1d9620de5dc3f779132cb"
    sha256 cellar: :any_skip_relocation, catalina:     "750182bb83130c00ce6a9ea828261aed154c5c9914a1965172575be861985088"
    sha256 cellar: :any_skip_relocation, mojave:       "3474f55537373be89128ac84c91a86f52cc10ac8a01934f784ae9ff07797ba43"
    sha256 cellar: :any_skip_relocation, high_sierra:  "da2e7d1937a9e47c96329261c76a3cc3ec445b0826b92115d3c48ab6885ca8a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a10a0a2c825a5d3e0b14d0115fcb18ec3190365678d397283d468a898bc6218e"
  end

  deprecate! date: "2021-06-02", because: :repo_archived

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"hello.c").write <<-EOS
      int printf(const char *, ...);
      int main() {
        printf("Hello, world!\\n");
      }
    EOS
    system bin/"swcc", "-o", "test", "hello.c"
    assert_match "Hello, world!", shell_output("./test")
  end
end
