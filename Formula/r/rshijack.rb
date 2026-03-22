class Rshijack < Formula
  desc "TCP connection hijacker"
  homepage "https://github.com/kpcyrd/rshijack"
  url "https://github.com/kpcyrd/rshijack/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "c13cc07825d72f09887ec0f098aa40d335f73a0bc0b31c4d1e7431271e1cb53e"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0ba456228f8c73b28433e29409a5949bb8e154794a30abf0058d4fb0db4febc6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ca2a8d042e51c65e54aab501b5c669008cda7783bed088b3ae59732a8aed823"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d85aa98cf1be3462acd931d1cb235f07adf3bafb9cc2d887c0abbba93a0401fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0a30c41da9c8e60505b84d5eb97c0db143d5a5d9c8cf1366bc10911505622fa1"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb638e32c2280602c4a9c2df3b7d44d2a13f18804cb2aebb841425c6b3e50f59"
    sha256 cellar: :any_skip_relocation, ventura:       "2ed78b00078532542588e9945636f4d386c09caf8e4f9f433604e3eb85eea21e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f0e4f5ac8ccd08299467e16abb5c3d6d198905ecd7c9ddaa58fc351aea744c4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7ac803fc3ef23e503bb4604c2c1322cdac87945b8337b5d30a19ee4917f3a84"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    interface = OS.mac? ? "lo0" : "lo"
    src = "192.0.2.1:12345"
    dst = "192.0.2.2:54321"

    output = shell_output("#{bin}/rshijack #{interface} #{src} #{dst} 2>&1", 1)
    assert_match "Waiting for SEQ/ACK to arrive", output

    assert_match version.to_s, shell_output("#{bin}/rshijack --version")
  end
end
