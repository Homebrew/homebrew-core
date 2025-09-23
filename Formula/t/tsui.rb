class Tsui < Formula
  desc "TUI for configuring and monitoring Tailscale"
  homepage "https://neuralink.com/tsui"
  url "https://github.com/neuralinkcorp/tsui/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "1ae87ad281587efbf80ef0bf9cc0b519dd4f08465cb378e34e97230f2f3526f0"
  license "MIT"
  head "https://github.com/neuralinkcorp/tsui.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c5aa985bc23f46808385ac73b79f5ebd81cb5e7281799bb8197e1c3bccd4f2d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3ca9c93120f6fb18fa2450a484d7ec1010c07b278303764c6e190465d56b0ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0194b896a9a93fc431be42723304fda6a1387587994f816979858f5572959d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8b6466361263798b364befe5c20bbd1e9190e10192c585f7748dc15c137db5e7"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c4f8cafa900e370bd481d335d58726d48065ec40990d55d4b7ceaf100cc8f4f"
    sha256 cellar: :any_skip_relocation, ventura:       "6fc53cdc2d15c3e8e6c0bfb5e506ecc143e2b674a331d91d2de345de0015177a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a10bf1333fdf6ac408c80c36c6259d1b31f8be73d5600909de9b2708f82ccb03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca260cc4f6d4e96c9067a627aa3b3018f2cedc2f687a9aee134a4367bd4cbefc"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "libx11"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    input, = Open3.popen2 "SHELL=/bin/sh script -q output.txt"
    input.puts "stty rows 80 cols 130"
    input.puts bin/"tsui"
    sleep 10
    input.putc "q"
    input.puts "exit"
    sleep 10
    input.close
    sleep 10

    screenlog = (testpath/"output.txt").read
    # remove ANSI colors
    screenlog.encode!("UTF-8", "binary",
      invalid: :replace,
      undef:   :replace,
      replace: "")

    assert_match(Regexp.union(
                   /Status:\s+(Not )?Connected/, # If Tailscale running
                   /Failed to connect to local Tailscale daemon/, # If Tailscale not running
                 ), screenlog)
  end
end
