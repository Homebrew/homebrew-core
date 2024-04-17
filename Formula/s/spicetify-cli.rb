class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https://github.com/spicetify/spicetify-cli"
  url "https://github.com/spicetify/spicetify-cli/archive/refs/tags/v2.36.5/v2.36.5.tar.gz"
  sha256 "b261b55c78f1dd631034d47dc040e904c5807aaeae540e698038cf42fcf3873f"
  license "LGPL-2.1-only"
  head "https://github.com/spicetify/spicetify-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2f78ad7ddbfa89114b0b56c7059dd7e2a257f853e179bf23eef6eb0a51c37334"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8610eec23bff18e410303d51dfcf17554e8429edb31188ec7bcd271107e4c987"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ffb25d2d4ac328a5f246f72725fd7c29cc044cff92c106509960ffda9209d178"
    sha256 cellar: :any_skip_relocation, sonoma:         "b9f914f4a9e6193b8d0adbdd1ce415800a7cae205d1477c691a0c5eab90f759a"
    sha256 cellar: :any_skip_relocation, ventura:        "d6d5f613d3f93f4cecb756b306d4cf4a76d7dc2296b97dc530ba4dcfd5631cb0"
    sha256 cellar: :any_skip_relocation, monterey:       "310f0e456304d5c214110bae4c2c535644829001825833d4c93ee9d195a77ac0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f21bbee8b778f12741cb8843954f91bd8bdaabfeb2e3c7a13bf702dc771e662c"
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
