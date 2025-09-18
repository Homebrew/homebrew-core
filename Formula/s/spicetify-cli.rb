class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https://spicetify.app/"
  url "https://github.com/spicetify/cli/archive/refs/tags/v2.42.0/v2.42.0.tar.gz"
  sha256 "ff5a3f5146a3e316178487154efe0bdc7ef5abbd95274d3fc59ec21d03df4fc4"
  license "LGPL-2.1-only"
  head "https://github.com/spicetify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f8b358274e47af11a5d99cd5cb08a2fc3c0744aad14915b659dbdaadeed98d41"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8b358274e47af11a5d99cd5cb08a2fc3c0744aad14915b659dbdaadeed98d41"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8b358274e47af11a5d99cd5cb08a2fc3c0744aad14915b659dbdaadeed98d41"
    sha256 cellar: :any_skip_relocation, sonoma:        "cf2642739b56ab4fc4a73421a59f586e42f968db4b2e6a9b82cbbae65f0a469f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8020cfdabc4bf1b4967250944815e03cb8f8b5856ac4b19b71210c1ba67a7f7"
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
