class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https://spicetify.app/"
  url "https://github.com/spicetify/cli/archive/refs/tags/v2.40.10/v2.40.10.tar.gz"
  sha256 "74f873330092f3026069f58a3606062980732cf4343825c0a2110db6e5f06652"
  license "LGPL-2.1-only"
  head "https://github.com/spicetify/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50a38d9da93c51ca1955394612eb88a87b0b6b7c18f52aa8d1643f576bb172f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50a38d9da93c51ca1955394612eb88a87b0b6b7c18f52aa8d1643f576bb172f2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "50a38d9da93c51ca1955394612eb88a87b0b6b7c18f52aa8d1643f576bb172f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c1c24eab8c87e05f92efac574ca034715a9be48d70cca11525d01b5d9bd9b90"
    sha256 cellar: :any_skip_relocation, ventura:       "1c1c24eab8c87e05f92efac574ca034715a9be48d70cca11525d01b5d9bd9b90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a81c1dd97566379e4044b1f563e90dcbfe7d1c3a8b134ef32358a9ea73091038"
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
    path.write <<~INI
      [Setting]
      spotify_path            = #{spotify_folder}
      current_theme           = SpicetifyDefault
      prefs_path              = #{pref_file}
    INI

    quiet_system bin/"spicetify", "config"
    assert_match version.to_s, shell_output("#{bin}/spicetify -v")

    output = shell_output("#{bin}/spicetify config current_theme 2>&1", 1)
    assert_match "com.spotify.Client is not a valid path", output
  end
end
