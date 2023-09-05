class Svls < Formula
  desc "SystemVerilog language server"
  homepage "https://github.com/dalance/svls"
  url "https://github.com/dalance/svls/archive/refs/tags/v0.2.9.tar.gz"
  sha256 "627887f4b105a024c31cd09c9baee9389e70652e85fa8231e5c52079db8dfeb3"
  license "MIT"
  head "https://github.com/dalance/svls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b06287783f54ef95e571ffd12a214bd81de29c817255ead7258a5e467807daeb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f78f78fc86bff699caa5832095c15e37b7d8f0b259deac4b86785b86048142c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0e671644f9f09d8f210f8bc02ccdeb11e26551ed6456a4e0ac91e6c5f951a948"
    sha256 cellar: :any_skip_relocation, ventura:        "98f6fe41cc18bb5f1d507780ea69a440d86b5fcb3826b5fe8f854bb4f5e94173"
    sha256 cellar: :any_skip_relocation, monterey:       "b0e1874174a3b202d0f18ea02a1518944335f81717ca744dda7473370d79c40a"
    sha256 cellar: :any_skip_relocation, big_sur:        "4005d141644426bed9ebebba0342fd61aa7a0d1a9c2d7bbe76b29ebfd0313f0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f69b4da91e6b1d0a49751e5426042a184795acb3b54a7d9c560934fabe96f16c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = /^Content-Length: \d+\s*$/
    assert_match output, pipe_output(bin/"svls", "\r\n")
  end
end
