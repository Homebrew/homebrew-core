class Toipe < Formula
  desc "Yet another typing test, but crab flavoured"
  homepage "https://github.com/Samyak2/toipe"
  url "https://github.com/Samyak2/toipe/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "31e4c7679487425254ad90bbc4d14a9bd55af6c6a20cce0b3f8eaa52fffe6bf7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "e5069bda110d16a90d262f87fccd6e4029d144bfa2f3f3c5a33e47117efb2221"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "d409f827261750a1cee4855aaba29da4ca9dca009b7e82485e079d4e66b38de0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e0ce4d37eded9cca126146d2d64a07c8fc668d030bc661107ea85ac3f2e4289f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a3ad889e7f6b27f58aa6ee57a24fd5265b373e5cac9b1dd7bb941e2212d30a6a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a57c6209f87c4aee533f7af560b00e6a789f93538a79d73db02d52609ff0fad"
    sha256 cellar: :any_skip_relocation, sonoma:         "638314ee280e0178d2a5fd3df5b83ed79ad4800fa6124ff55c691b15841a6b99"
    sha256 cellar: :any_skip_relocation, ventura:        "dcf1654718d4a6f1b6e5c12ba277bc2f033609d4a4a576d247e45b81bab90a9a"
    sha256 cellar: :any_skip_relocation, monterey:       "00fc421a810c0416cdf3ff8125af6f8f3fcf59a489087057f8128ad30130f1c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "a761b2cd6f5ccb7f6fff0ea85a7cfad080dd73bdc13a065f6e42bfb1768da455"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8017e2889572c9c07f45b7a7f394cbfbd0267e50b408eba36fba5d13cf24521b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "pty"
    PTY.spawn(bin/"toipe") do |r, _w, pid|
      output = r.gets
      assert_match "ToipeError: Terminal height is too short! Toipe requires at least 34 lines", output
    ensure
      Process.kill("TERM", pid)
    end

    assert_match version.to_s, shell_output("#{bin}/toipe --version")
  end
end
