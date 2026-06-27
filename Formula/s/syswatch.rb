class Syswatch < Formula
  desc "Cross-platform system diagnostics TUI"
  homepage "https://www.netwatchlabs.com/labs/syswatch"
  url "https://github.com/matthart1983/syswatch/archive/refs/tags/v0.7.3.tar.gz"
  sha256 "7e5f1398ee763bee1f5b52cb0b3816976020d8b1fd6dc18eb797318b8b637ad5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ca8947564192a16f8f404d136cda5377289daf02c0516f69dac5dc131d767e7e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fba1d39246b00faf7aae5c0daa138074346920a601b8e8a4197b4ba4f4d12e18"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "260fda7ee9b254af24e2bc50567794aaf68931d8adead600009e01927e32e7f8"
    sha256 cellar: :any,                 arm64_linux:   "0eea1251db64066ad5f7127798f058bd06d6adb34710f61c46225a9b1a171600"
    sha256 cellar: :any,                 x86_64_linux:  "544d9b26aebf35f3ba8ff93fc78cabd5efc6437e735d21c55cddfac4b2f31750"
  end

  depends_on "rust" => :build

  on_macos do
    depends_on arch: :arm64 # test fails on Intel macOS
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    Open3.popen2("script", "-q", "screenlog.txt") do |input, _, wait_thr|
      input.puts "stty rows 80 cols 130"
      input.puts "env LC_CTYPE=en_US.UTF-8 LANG=en_US.UTF-8 TERM=xterm #{bin}/syswatch"
      sleep 1
      # bring up help dialog
      input.puts "?"
      sleep 1
      input.close
    ensure
      Process.kill("TERM", wait_thr.pid)
    end

    screenlog = (testpath/"screenlog.txt").read
    assert_match "Services", screenlog
    # match text in help dialog
    assert_match "Procs tab", screenlog
  end
end
