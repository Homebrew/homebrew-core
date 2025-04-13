class Senpai < Formula
  desc "Modern terminal IRC client"
  homepage "https://sr.ht/~delthas/senpai/"
  url "https://git.sr.ht/~delthas/senpai/archive/v0.4.0.tar.gz"
  sha256 "ff5697bc09a133b73a93db17302309b81d6d11281ea85d80157f1977e8b1a1e2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33a66487e2355b56acee1ffec16ed16f308a977b3c1abd2d9db9570e7b658865"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ac79b7d2f6c2606508ea901e09fbe56fd38397e129341d70ab0868b18b8bd0d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dcec36ef850698f5e64f3ebb7cf50c2b5b348fc5fc360c90be5a6af17ef2cd71"
    sha256 cellar: :any_skip_relocation, sonoma:        "141ce7474d65491002192e687b9024e57d52e0ad7088bb8b0dd238e060b005b6"
    sha256 cellar: :any_skip_relocation, ventura:       "a74821305335966d463581a4f0da5d1c3378c089b1d8e7084bc0dd44b598090b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef0f138f38ce2da617d0c8de276d6e27a6b92f2ff6579d4a67756385ec7be8d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "247b7f95552167eb3f3aa9c7c6f19560c305ff6edc115a63c5aa8235b8fb8750"
  end

  depends_on "go" => :build
  depends_on "scdoc" => :build

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    require "pty"

    stdout, _stdin, _pid = PTY.spawn bin/"senpai"
    _ = stdout.readline
    assert_equal "Configuration assistant: senpai will create a configuration file for you.\r\n", stdout.readline
  end
end
