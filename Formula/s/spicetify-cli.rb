class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https://spicetify.app/"
  url "https://github.com/spicetify/cli/archive/refs/tags/v2.42.7/v2.42.7.tar.gz"
  sha256 "1660dda2205f840d90dfe6810963f0c42b4759eda865d26eff7c963bd55f36d6"
  license "LGPL-2.1-only"
  head "https://github.com/spicetify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f76b3c050cfed4796bbaf12665fa750d467baaa11309633c16bbf735d469941d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f76b3c050cfed4796bbaf12665fa750d467baaa11309633c16bbf735d469941d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f76b3c050cfed4796bbaf12665fa750d467baaa11309633c16bbf735d469941d"
    sha256 cellar: :any_skip_relocation, sonoma:        "0da33a8bdd08a6562ad41cbdeb79e37cf62cb807095d9a53bab04e2d06ce32de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "70093ef3055fa0a609863ac41197425a5ef2a27bc232784edeb908360e5fe784"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b55bbe2dea7e02101728c85fa0cbf2e131d30499d87948d7510976dacd1cdb24"
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

    output = shell_output("#{bin}/spicetify config current_theme")
    assert_match "SpicetifyDefault", output
  end
end
