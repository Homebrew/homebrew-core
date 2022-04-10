class Twty < Formula
  desc "Command-line twitter client written in golang"
  homepage "https://mattn.kaoriya.net/"
  url "https://github.com/mattn/twty/archive/refs/tags/v0.0.12.tar.gz"
  sha256 "e395f0ea184e20369c726dcee143a2710c478af0de6f2ffad1093a4eb517805e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "efc7066b76cd6a843d2352df68739ea68c363026d3200eb2500a707b37ff8293"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "86e295484da584bc71bbc2cf683541c4c229fc5e6e4ae2c9055c3878ca708f53"
    sha256 cellar: :any_skip_relocation, monterey:       "2db03388ef1a178c4cf9a75f1113155d43398de4919290eb200e27336c2eca8f"
    sha256 cellar: :any_skip_relocation, big_sur:        "7bb35521b55d8bacfbecf84d429338c85b509082866c148da8b68c9a416eb1a4"
    sha256 cellar: :any_skip_relocation, catalina:       "040af36922d044a811cba87a028c9eb60412f3d8b99b9a4a92359b9fb4894abb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a41c042053f83dc23bbb04a10c129d07668cf92b9db57beb2da546a896c21140"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

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
    PTY.spawn(bin/"twty") do |r, w, _pid|
      assert_match "Open this URL and enter PIN.", r.gets
      assert_match "https://api.twitter.com/oauth/authenticate?oauth_token=", r.gets
      w.puts
      sleep 1 # Wait for twty exitting
    end
  end
end
