class Smenu < Formula
  desc "Powerful and versatile CLI selection tool for interactive or scripting use"
  homepage "https://github.com/p-gen/smenu"
  url "https://github.com/p-gen/smenu/releases/download/v1.5.0/smenu-1.5.0.tar.bz2"
  sha256 "2de2217d322a5e28cb20f9128e60df6c00b4e8e8879381ac8ed8bdcdccc4c5ca"
  license "MPL-2.0"

  # Exclude release candidate tags
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "78a219ab9e9b09653e73a48168c5acf40cf2f2cbe40d4cb3280baab5fbd6bd60"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "680882f063d437bba1303cea04f8f9124f0b968c842c2604684146716631eade"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b8d5074b8284658922ef4cd3590cfa37c26d9decfe9a83b79d807d1031849b6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "06eec1603896abc1d532b34543758e15560c5146bc1a6c54ce49254c25c794ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "491e32cc6c966d6edbeedae5c8b76968b28a7f07e522ff22bbcab1a040424795"
    sha256 cellar: :any_skip_relocation, ventura:       "680bc214f78a5a4dbb8668244a4c700fbe1d54fe41547fb73bf694c4d7048057"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e85de8deb4fd6158ba1d6d22dc58c1364ece296b58dcb87027ded530e24d7e76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb922f2d14b6ee961ce7f50015069b2877a539fe14e9661b63d2a195df3b83fa"
  end

  uses_from_macos "ncurses"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    require "pty"

    PTY.spawn(bin/"smenu", "--version") do |r, _w, _pid|
      r.winsize = [80, 60]

      begin
        assert_match version.to_s, r.read
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    end
  end
end
