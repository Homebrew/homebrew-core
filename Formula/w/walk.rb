class Walk < Formula
  desc "Terminal navigator"
  homepage "https://github.com/antonmedv/walk"
  url "https://github.com/antonmedv/walk/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "1d611d683c6764de089971e838dd8462dc1d6e63b3faf1a8f8d2a144d7264a3e"
  license "MIT"

  bottle do
    manifest_sha256 "f8081014c2f8299a86d097dc0847e5b8bfc27a11007a5a0bc30ee887dbf7e491"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7367d2050ec4bcabe7e857457ecdc234744a42fe1ff1f7c0bc0dc3270c54ab0d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7367d2050ec4bcabe7e857457ecdc234744a42fe1ff1f7c0bc0dc3270c54ab0d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7367d2050ec4bcabe7e857457ecdc234744a42fe1ff1f7c0bc0dc3270c54ab0d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "515d548fac0ee436412ff1200882739ededd1d8e5f722de7a0bff1444e13f9ad"
    sha256 cellar: :any,                 x86_64_linux:      "3cca4907a91fb746e410698dac86fdcef04e2f2cb02a8b813a7d882486883318"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args
  end

  test do
    require "pty"
    require "expect"

    PTY.spawn(bin/"walk") do |r, w, _pid|
      r.winsize = [80, 60]
      # walk waits for replies to its terminal background colour and cursor position queries
      r.expect("\e[6n", 10)
      w.write "\e]11;rgb:0000/0000/0000\e\\\e[1;1R"
      sleep 1
      w.write "\e"
      begin
        r.read
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    end
  end
end
