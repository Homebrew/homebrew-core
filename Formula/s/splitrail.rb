class Splitrail < Formula
  desc "Real-time token usage tracker and cost monitor for CLI coding agents"
  homepage "https://splitrail.dev/"
  url "https://github.com/Piebald-AI/splitrail/archive/refs/tags/v3.7.2.tar.gz"
  sha256 "91832298ac6af26d26d6706acb14c8d5e630d3eb80b8fb2e22f34f522275e1fb"
  license "MIT"
  head "https://github.com/Piebald-AI/splitrail.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6569bff97eec320ce5308a6e466737381ae57ebcf0a01c8584b5ca1d2a117a1a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c9883587cc373596149ec553ed011d4a9349092a2c5e239afeb91e031f6e8a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "09aeae3e0e61e7003e13ab799ac9e18eebf3cefafb41b64f60eb289762509f5a"
    sha256 cellar: :any_skip_relocation, sonoma:        "a9fdf5cb676d311a70081fe939ddfe89cb65e9a2b5ea8935814deab8c5e13603"
    sha256 cellar: :any,                 arm64_linux:   "b4237a59264067f5c65200c5c7a0f8511a42facb716a254d122d46e5b477730b"
    sha256 cellar: :any,                 x86_64_linux:  "0f07e34a90c39850638248996067bc8e1a36bbd379ebaa2cc068ad50328eedc5"
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
