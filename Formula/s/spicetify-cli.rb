class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https://spicetify.app/"
  url "https://github.com/spicetify/cli/archive/refs/tags/v2.42.14/v2.42.14.tar.gz"
  sha256 "d03c5fc93db5a6ddae2410339995287bd05b3edb9d2bde8998568f18dd2e42ed"
  license "LGPL-2.1-only"
  head "https://github.com/spicetify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "950730c2b988cbdb3d767d14f040a2ceda160aae403069cb706230ab5bedba25"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "950730c2b988cbdb3d767d14f040a2ceda160aae403069cb706230ab5bedba25"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "950730c2b988cbdb3d767d14f040a2ceda160aae403069cb706230ab5bedba25"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c90a0f2a2ba7c7ac3e9bb00e43d685e760198997aca41908c734c100ba0192b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f3e6e31e00e87b504fabbc9fde86022a75f9454f3b000ba3de09bebdc1d1bbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "895e354a8dc81d2d1674f69ba678a9ed3adebc1297562228323c64bb8a8fcf0a"
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
