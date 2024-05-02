class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https://github.com/spicetify/spicetify-cli"
  url "https://github.com/spicetify/spicetify-cli/archive/refs/tags/v2.36.9/v2.36.9.tar.gz"
  sha256 "8e258dc46c913a7f0a97f5b0d1306c7cf9abd0dc806e45d076500f8e1e39c30c"
  license "LGPL-2.1-only"
  head "https://github.com/spicetify/spicetify-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "470e0a6add40ea4bb6103ff5add310b2c0dddd61178b53d6478cf9d98e98bfa2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "07df397ebb56e325e6c2ee0d1a1183a605ccf0cf3f77f6668129eb0c6160544a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "99b2d5d558c50dcb9dc0f2936005932c806cfa564bf1487721015c305c61e343"
    sha256 cellar: :any_skip_relocation, sonoma:         "dfe298b4a006a5726c3a0162538075abba572bcd07f464e1f53bfaa9877109e8"
    sha256 cellar: :any_skip_relocation, ventura:        "d65464738cfb92a700339523aac26c54b9fedb6e4fecc5df2537379f9a94214b"
    sha256 cellar: :any_skip_relocation, monterey:       "7d482b11dbb9bd379b75f7cbb0c5738f3db646e90142f2feb1a1cbfe941ee758"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "165683d331ba46b4ab0e00460abd1b46d500a50578ea2ae19425c1018538ac0d"
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
