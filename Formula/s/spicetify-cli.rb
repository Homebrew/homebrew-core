class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https://spicetify.app/"
  url "https://github.com/spicetify/cli/archive/refs/tags/v2.42.1/v2.42.1.tar.gz"
  sha256 "708eca485200c04656f5336954392431b851af27fc78c6d643fc6937a0c0362e"
  license "LGPL-2.1-only"
  head "https://github.com/spicetify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "347c4073618b6855e01b9f9372264a43193a34e291f347a2b36b5ef475ed419a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "347c4073618b6855e01b9f9372264a43193a34e291f347a2b36b5ef475ed419a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "347c4073618b6855e01b9f9372264a43193a34e291f347a2b36b5ef475ed419a"
    sha256 cellar: :any_skip_relocation, sonoma:        "e9ee34463066fdd3ae610b1df68d504e4646464aefebd7eada46c1992afc7e5a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0aba2bab7f1f67ffb19bf22201c64cab814b7b07e7d7824937b13f5316dc390d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "504b257c7e0093044036e45b2096d3bd5b6257a496f13044b7bf2e12ccec02ca"
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
