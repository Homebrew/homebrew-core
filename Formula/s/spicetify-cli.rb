class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https://spicetify.app/"
  url "https://github.com/spicetify/cli/archive/refs/tags/v2.39.6/v2.39.6.tar.gz"
  sha256 "a095c7dd7bd2cdec47c31770dd647532fda0444de451bd42f5a076eaf2e5d497"
  license "LGPL-2.1-only"
  head "https://github.com/spicetify/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b16853b89322caca1676ac1dcaa31298e1e4e48325b46cbfaa1f4dad514c4a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b16853b89322caca1676ac1dcaa31298e1e4e48325b46cbfaa1f4dad514c4a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0b16853b89322caca1676ac1dcaa31298e1e4e48325b46cbfaa1f4dad514c4a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b90cb2f31b4689e106785ea91b4b7401c417f1b440baffec919408c84a97d6f"
    sha256 cellar: :any_skip_relocation, ventura:       "3b90cb2f31b4689e106785ea91b4b7401c417f1b440baffec919408c84a97d6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fcfd64600ddf66aad0df96a2c42aa100f8e223141e320b4ea929974f3b859a00"
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
