class TRec < Formula
  desc "Blazingly fast terminal recorder that generates animated gif images for the web"
  homepage "https://github.com/sassman/t-rec-rs"
  url "https://github.com/sassman/t-rec-rs/archive/v0.7.3.tar.gz"
  sha256 "8da8681b6632a95d05c6461fcbf0e4b9dc93e523957c8b34aeba3fc08aeddbcc"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3bbd03ac1450b9374153511aa656e6bdf042c4eab97efab328b0c2545c7b3a69"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1e3517d2237d18fb22f885564d3e39412c27c616c0bc7c827b20067b8f93b995"
    sha256 cellar: :any_skip_relocation, monterey:       "c1a2e54084ffc7671e3719090cf74984ff3cdb9c56fc14dfc76b7918b65b60ea"
    sha256 cellar: :any_skip_relocation, big_sur:        "777cb5fda48e7c58855c91c321991a07a7608fdf80805a9dbeeedda22110707e"
    sha256 cellar: :any_skip_relocation, catalina:       "6239d0a1d3118aad1b70bf982bd5d9473dc9b73a9aeda32daab34f679d76a133"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8dd4a1546273b6940595a713ab26df6e4534a7924ba8781fba50e4cdd735bda"
  end

  depends_on "rust" => :build
  depends_on "imagemagick"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    o = shell_output("WINDOWID=999999 #{bin}/t-rec 2>&1", 1).strip
    if OS.mac?
      assert_equal "Error: Cannot grab screenshot from CGDisplay of window id 999999", o
    else
      assert_equal "Error: Display parsing error", o
    end
  end
end
