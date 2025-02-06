class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https://github.com/spicetify/cli"
  url "https://github.com/spicetify/cli/archive/refs/tags/v2.38.9/v2.38.9.tar.gz"
  sha256 "f940cbf381aa8278e1e250875d4ed0a589ba726cc4da542b77afe93fb8df8311"
  license "LGPL-2.1-only"
  head "https://github.com/spicetify/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c798adedaa6566991afadddf9a83b58f84641c94771ab6d802ba70d9fb9811d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c798adedaa6566991afadddf9a83b58f84641c94771ab6d802ba70d9fb9811d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c798adedaa6566991afadddf9a83b58f84641c94771ab6d802ba70d9fb9811d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "afad761372a20d17dbf0ebd602fcc4220aa8b7783239c9d43f8cc23f03f21f4b"
    sha256 cellar: :any_skip_relocation, ventura:       "afad761372a20d17dbf0ebd602fcc4220aa8b7783239c9d43f8cc23f03f21f4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d2937c1e12b9dc9ffbf393530a631c8da8912c417a5d0fc004738a2fbdc3764"
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
