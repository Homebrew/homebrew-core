class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https://spicetify.app/"
  url "https://github.com/spicetify/cli/archive/refs/tags/v2.40.11/v2.40.11.tar.gz"
  sha256 "64575466e75fc0909a14ce3e82bdfa4ecd0fee55556a27d50e5eeb7db6aa1656"
  license "LGPL-2.1-only"
  head "https://github.com/spicetify/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a109dad77ff112a3d2ccce59f214281087cf056dbf2484c8bf5e78cf865f08a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a109dad77ff112a3d2ccce59f214281087cf056dbf2484c8bf5e78cf865f08a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a109dad77ff112a3d2ccce59f214281087cf056dbf2484c8bf5e78cf865f08a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3b0ebc2290197e6122408273937b93fe45ca8d6318480146730a7639df3dfd6"
    sha256 cellar: :any_skip_relocation, ventura:       "d3b0ebc2290197e6122408273937b93fe45ca8d6318480146730a7639df3dfd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7c247c53606d21b002849fe97aabc4337f42a9931fee0db2c3fcd8be50edc06"
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
