class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https://spicetify.app/"
  url "https://github.com/spicetify/cli/archive/refs/tags/v2.43.1/v2.43.1.tar.gz"
  sha256 "f7f577c90e9b6e502ab05891f83f657038beded57bd6d09ab4421f87bc2542dd"
  license "LGPL-2.1-only"
  head "https://github.com/spicetify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f915ac4a92372340a3c401a6a2e0e4340d326b1f013efc5cc2fda4e88c893385"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f915ac4a92372340a3c401a6a2e0e4340d326b1f013efc5cc2fda4e88c893385"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f915ac4a92372340a3c401a6a2e0e4340d326b1f013efc5cc2fda4e88c893385"
    sha256 cellar: :any_skip_relocation, sonoma:        "178975b0e86cb47aa92367ac81c41d28669147fe361efa03c3a91e21b15ef5b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "877154d9db62466bd47b1e2d1eec46df1399eafc950270fb26dcbd4ef68bad76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ae2532229639d188d8a89cc4d66a13541fb2dd713498b6200d8b1be770879f9"
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
