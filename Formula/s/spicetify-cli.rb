class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https://github.com/spicetify/spicetify-cli"
  url "https://github.com/spicetify/spicetify-cli/archive/refs/tags/v2.34.1/v2.34.1.tar.gz"
  sha256 "13f8582cc5aa3ec3d2b89d41d3241628ed65dd0c2b090d7572c7594d3b220c7a"
  license "LGPL-2.1-only"
  head "https://github.com/spicetify/spicetify-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "70a491cfbd28e07732ab994eed66ef791d6d0fc305c05543931d86582a70158f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a369631a46830a35cedffaeda91468aba23625189b8d59dd48cf8ccff2d96613"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a8a8ec92e0b6b20af4ff58efb948a13cfdea3c07ef12d43bb9954b04093657e"
    sha256 cellar: :any_skip_relocation, sonoma:         "bf32af6721cc7d4f5e6e554449ae0c8ea57fc4d9b6679082f116216e9fb9bf31"
    sha256 cellar: :any_skip_relocation, ventura:        "b4f71f3ea3ed837f0eeaebe105f92b4b644a6aea5369b46c3e36a14e6b9ca0b6"
    sha256 cellar: :any_skip_relocation, monterey:       "5cdc29be5182577b04b99fdb6c8b40c0de87515ef770a3e09c3532bad0d23226"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ccf6048cbca168ae2ffbc62f8b252ebb83c73b1136a3e23c35600d6edbb58a89"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: libexec/"spicetify")
    cd buildpath do
      libexec.install [
        "css-map.json",
        "CustomApps",
        "Extensions",
        "globals.d.ts",
        "jsHelper",
        "Themes",
      ]
      bin.install_symlink libexec/"spicetify"
    end
  end

  test do
    spotify_folder = testpath/"com.spotify.Client"
    pref_file = spotify_folder/"com.spotify.client.plist"
    mkdir_p spotify_folder
    touch pref_file
    path = testpath/".config/spicetify/config-xpui.ini"
    path.write <<~EOS
      [Setting]
      spotify_path            = #{spotify_folder}
      current_theme           = SpicetifyDefault
      prefs_path              = #{pref_file}
    EOS
    quiet_system bin/"spicetify", "config"
    assert_match version.to_s, shell_output("#{bin}/spicetify -v")
    assert_match "SpicetifyDefault", shell_output("#{bin}/spicetify config current_theme")
  end
end
