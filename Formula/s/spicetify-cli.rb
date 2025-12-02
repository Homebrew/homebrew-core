class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https://spicetify.app/"
  url "https://github.com/spicetify/cli/archive/refs/tags/v2.42.3/v2.42.3.tar.gz"
  sha256 "2d1108bff0b3b6232e34b417fc7ff00fa661a04afd23f4ed877f2514696ab197"
  license "LGPL-2.1-only"
  head "https://github.com/spicetify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ea50d0d42290e41956ab9df15b01d5534dd8bf48e1cab0ce38051b745e7e630e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea50d0d42290e41956ab9df15b01d5534dd8bf48e1cab0ce38051b745e7e630e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea50d0d42290e41956ab9df15b01d5534dd8bf48e1cab0ce38051b745e7e630e"
    sha256 cellar: :any_skip_relocation, sonoma:        "b4630c4e27c56f8179f57519a323c21ff8a994e373f6bcc93b03682c67599afe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b618a5f3c73928457c4f693f58317d9cd8996be4327338e4393c90d11cbdd403"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7916911c0285b5b6607ed29bdd0d9ac3e6c5fa3d07d4d2aa0c690bee7923e7f3"
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
