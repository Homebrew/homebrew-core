class RipgrepAll < Formula
  desc "Wrapper around ripgrep that adds multiple rich file types"
  homepage "https://github.com/phiresky/ripgrep-all"
  url "https://github.com/phiresky/ripgrep-all/archive/v0.9.6.tar.gz"
  sha256 "8cd7c5d13bd90ef0582168cd2bef73ca13ca6e0b1ecf24b9a5cd7cb886259023"
  license "AGPL-3.0"
  head "https://github.com/phiresky/ripgrep-all.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "51ec0645f247775918f4a4185617fe769151b9ceec8edc71be5b60728b7f49f2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c9fa77ff1abf533bbb2e04f19dffda6aa82379e2f6130871c8619665985eec0d"
    sha256 cellar: :any_skip_relocation, monterey:       "3369e565e0e3670f7e31602d2a8c5eaa090590d4fe3b0f32208ec5d7cdd11818"
    sha256 cellar: :any_skip_relocation, big_sur:        "b24dbd82ac065540c5aaa73fcde2d502a0d463f6c8dceb4be30bacc9335bdef5"
    sha256 cellar: :any_skip_relocation, catalina:       "bc8ee7c7869c23b82cb1997e4f7f5024193b74cc282c20c6bf50af43b55ddbb4"
    sha256 cellar: :any_skip_relocation, mojave:         "b1b26781f754760e790ff28c7a26079eb9df86b983c786cd745eabac0232c861"
    sha256 cellar: :any_skip_relocation, high_sierra:    "59001d904ce02e54e23842a7d04f9729d41f1e6fd8b81a71676812be5c6a20f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eadaa96c3eed82db9b74c68612ac1f43e11a27e4d31b3433a631d2b732282e3d"
  end

  depends_on "rust" => :build
  depends_on "ripgrep"

  uses_from_macos "zip" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"file.txt").write("Hello World")
    system "zip", "archive.zip", "file.txt"

    output = shell_output("#{bin}/rga 'Hello World' #{testpath}")
    assert_match "Hello World", output
  end
end
