class TreCommand < Formula
  desc "Tree command, improved"
  homepage "https://github.com/dduan/tre"
  url "https://github.com/dduan/tre/archive/v0.4.0.tar.gz"
  sha256 "280243cfa837661f0c3fff41e4a63c6768631073c9f6ce9982d9ed08e038788a"
  license "MIT"
  head "https://github.com/dduan/tre.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea7a96260ab0d61ca2e71c5137635625e82472fd2935280dd9420d5eee1c5744"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "838817c4d488d31f1c2f89abbde6704eba4b775b09f4a33b0de720ca1a7b1191"
    sha256 cellar: :any_skip_relocation, monterey:       "385a5a7ea1ff28970a7ca8145868bbd7eb0efa4e5439ecb258cb66303ffcab0c"
    sha256 cellar: :any_skip_relocation, big_sur:        "c1f07d73da700d15a4cdec3c309d54c6e4bf1091ad9c42784ca395f28432ed13"
    sha256 cellar: :any_skip_relocation, catalina:       "150205b5b64c4a27a5fc9462d0aeedc14c26719473c0d180d892505926692dd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da73bacbf146c92851ab02ccc5fb6c643ab43fbfb8b88dae659c70604750e5c9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "manual/tre.1"
  end

  test do
    (testpath/"foo.txt").write("")
    assert_match("── foo.txt", shell_output("#{bin}/tre"))
  end
end
