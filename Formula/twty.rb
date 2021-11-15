class Twty < Formula
  desc "Command-line twitter client written in golang"
  homepage "https://mattn.kaoriya.net/"
  url "https://github.com/mattn/twty/archive/refs/tags/v0.0.11.tar.gz"
  sha256 "d1ee544ff31a9a9488ff759da587baf927ab7c31b191b4b5bc010f36ecfb8188"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "06c6d110c34b62edbc4300a9ab662397ed5a7cc8a8199786e5a746b4535a5bf1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "847a9c071620d78e35034cd4bd2b373813b9ba31501e13393d32177e7f26df59"
    sha256 cellar: :any_skip_relocation, monterey:       "20a8a7640416f893c3a4f09a51a62ce48eebceb382c9a13a9ea60b234c359114"
    sha256 cellar: :any_skip_relocation, big_sur:        "22e65cfb1d7eb35462798abf3795feef19b68d5aa61e90c580153b6d2d3915b5"
    sha256 cellar: :any_skip_relocation, catalina:       "4619c0ae9427727d3a456142fe9f574ad0f73bddbd24e8a6c194da7f610cf81d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35503d676346e1ec4f0467cd5851acb3787ce28a7b60849a08aa57ba7ae7bb02"
  end

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
    PTY.spawn(bin/"twty") do |r, w, _pid|
      assert_match "Open this URL and enter PIN.", r.gets
      assert_match "https://api.twitter.com/oauth/authenticate?oauth_token=", r.gets
      w.puts
      sleep 1 # Wait for twty exitting
    end
  end
end
