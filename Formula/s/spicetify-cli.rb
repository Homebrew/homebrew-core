class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https://spicetify.app/"
  url "https://github.com/spicetify/cli/archive/refs/tags/v2.42.10/v2.42.10.tar.gz"
  sha256 "b001354eabbaa165433a6ced8c0e0c590a40464a5b7a6fbaf7328a83bd7c0cc3"
  license "LGPL-2.1-only"
  head "https://github.com/spicetify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b188b0d3265424d6f322a706589d1173d0eb12684304b69b798c0ea081c9a0c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b188b0d3265424d6f322a706589d1173d0eb12684304b69b798c0ea081c9a0c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b188b0d3265424d6f322a706589d1173d0eb12684304b69b798c0ea081c9a0c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "e873ffd07791cfa31b861b6d8f59d1c625f7534ea8c332997d3fbf2e4bf949dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61d3f77028f777cc33b79d54bbb49c4b22ca47d1654ec3ce668377da856b16c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ecf577a746b7296861599bf9bf1c16cd1c6d9b1f98783d9cd598f7a81f63eec3"
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
