class Splitrail < Formula
  desc "Real-time token usage tracker and cost monitor for CLI coding agents"
  homepage "https://splitrail.dev/"
  url "https://github.com/Piebald-AI/splitrail/archive/refs/tags/v3.7.1.tar.gz"
  sha256 "e0cd15d78e38f7813edab999ce7cfc7f7dcc3c89c582dd3d39c387e273c542f9"
  license "MIT"
  head "https://github.com/Piebald-AI/splitrail.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "94509d6d762b205cb207d0de7804636bff3fd823bd02035a3bdcd0e6b353d743"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2bd66ceec300b441392be9b9b42496cd8c183c1d7e982cb2e425844473be8570"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e7206dde5fb92dae0eb42b3ba0cce3c55662da4228ccf5544047fd4d623cb18"
    sha256 cellar: :any_skip_relocation, sonoma:        "e5e3a08ff0ee294de0b7142e066756f72b49bfe4f19f260c023bd222c7207c66"
    sha256 cellar: :any,                 arm64_linux:   "926488ee2d4c39e8b501d0fffc79e569b9a93834fbab1256599db8cf1a3196ee"
    sha256 cellar: :any,                 x86_64_linux:  "769b7fe08794b638f600b0594ed7af6d392bd1a8ba62d684ce6c86ba752cda55"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/splitrail --version")

    output = shell_output("#{bin}/splitrail config init")
    assert_match "Created default configuration file", output
    assert_match "[server]", (testpath/".splitrail.toml").read
  end
end
