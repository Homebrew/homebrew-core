class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https://github.com/spicetify/spicetify-cli"
  url "https://github.com/spicetify/spicetify-cli/archive/refs/tags/v2.36.0/v2.36.0.tar.gz"
  sha256 "e6135c9cac9ae79d0ecf441ff7bb89bfe486cb5d6867225c9dc92d56dda9029a"
  license "LGPL-2.1-only"
  head "https://github.com/spicetify/spicetify-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9116842b5dc2ac09c634a460a730cbfa60f32802eb7057c476adc050572b9517"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "abd8f1cbd8d158fcb215c00b0b1bcae3ac8a30c7ecdda32177fb2f4c217c5b6b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd94a4becdb8748b400e6d128cbd4e6f525c148f940c84feea166f8df21d2e0f"
    sha256 cellar: :any_skip_relocation, sonoma:         "32be43a9fd4e40ecd49c8c85bb7082e1ff7df80cef67842448d4d7c54c1cead4"
    sha256 cellar: :any_skip_relocation, ventura:        "c03494ac2e5e885e9e0e01caf7d60c4ecbb22b3c4d48e539fcc016fe53118ffc"
    sha256 cellar: :any_skip_relocation, monterey:       "5d71622a5fe585cf7a38bb18c402cedd23590906736c718588e4bfb5c9052fbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2dafa52698f1f125446e2115a68bf7cf3415b96b7a417aa0d92304a3a4727529"
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
