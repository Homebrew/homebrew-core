class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https://github.com/spicetify/cli"
  url "https://github.com/spicetify/cli/archive/refs/tags/v2.38.7/v2.38.7.tar.gz"
  sha256 "96b53a96d1f4d17fe218fc008a4ea99c2760027f1d0c69f39bdef171d6f0f8e3"
  license "LGPL-2.1-only"
  head "https://github.com/spicetify/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cee146270d62e24f7c0b9259488b46436ce6845d656cfa0a158e57640f1f73d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cee146270d62e24f7c0b9259488b46436ce6845d656cfa0a158e57640f1f73d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cee146270d62e24f7c0b9259488b46436ce6845d656cfa0a158e57640f1f73d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc8809d6deed80fc9c5261ffb590fe9a60d808d88e7b51890b4eb8034499866a"
    sha256 cellar: :any_skip_relocation, ventura:       "cc8809d6deed80fc9c5261ffb590fe9a60d808d88e7b51890b4eb8034499866a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "daf2d47ed395cbf9b8891879672caee0bfb8edbf11884c75ea636fb592263d36"
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
