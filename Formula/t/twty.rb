class Twty < Formula
  desc "Command-line twitter client written in golang"
  homepage "https://github.com/mattn/twty/"
  url "https://github.com/mattn/twty/archive/refs/tags/v0.0.13.tar.gz"
  sha256 "4e76ada5e7c5f2e20881fbf303fb50d3d4a443a8e37f2444371a90102737e49b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "06376606f273478b5bbcb8f781549cf79bf9b4cf596cc3a274104c1dca2704ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "455017b709a05e29e56106d6fafd24f4e9c09fba6d18bcc2b8a5173faf1d21c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f646e71ba538e0406565dde123ecea7cc153510e53abd19373d1bd3ec159173e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6bab324fcbfdfd720834fae87499bd2725318394393f63f277c0212d5a56ce4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cfda1fe3c8de3bec08877dfc0d1ed0c33c9f88094fb2514e23b724305ec15ee4"
    sha256 cellar: :any_skip_relocation, sonoma:         "020ce84c0f8943cc35f54c2bd93e1b115405b8a54b084dc30470dca34ab4a77b"
    sha256 cellar: :any_skip_relocation, ventura:        "5805a300e13f68dcbe7b998bab1c07bee79ad2d62e666a25c67e4ac73759b78f"
    sha256 cellar: :any_skip_relocation, monterey:       "de800aefbbc7f4299b2b8db41be41f8270c8bfda3b926e1e6fafa1d67c4bdcf1"
    sha256 cellar: :any_skip_relocation, big_sur:        "a77b1519634272bbb35b4f5fa588cc2cda46fc8aacf6414205291900e18a1ece"
    sha256 cellar: :any_skip_relocation, catalina:       "65a106670027565383dee061957cd83963dc4df76bd7725b4d4ae40b21bfdc55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb45326df2a5cb80531378ae156fc20400346d5c5c8d82548429b62463ec603e"
  end

  # see discussions in https://github.com/mattn/twty/issues/28
  # and https://github.com/orakaro/rainbowstream/issues/342
  disable! date: "2025-01-01", because: "uses the old, unsupported Twitter API"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    # Prevent twty executing open or xdg-open
    testpath_bin = testpath/"bin"
    ENV.prepend_path "PATH", testpath_bin
    testpath_bin.install_symlink which("true") => "open"
    testpath_bin.install_symlink which("true") => "xdg-open"

    # twty requires PIN code from stdin and putting nothing to stdin to make authentication failed
    require "pty"
    PTY.spawn(bin/"twty") do |r, _w, pid|
      output = r.gets
      assert_match "cannot request temporary credentials: OAuth server status 401", output
      assert_match "{\"errors\":[{\"code\":32,\"message\":\"Could not authenticate you.\"}]}", output
    ensure
      Process.kill "TERM", pid
    end
  end
end
