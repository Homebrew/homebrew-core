class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https://spicetify.app/"
  url "https://github.com/spicetify/cli/archive/refs/tags/v2.43.2/v2.43.2.tar.gz"
  sha256 "3debce8af8e071ff9ec75b6a8a296bbd0bb5963151721b0ad2723660b64f65c5"
  license "LGPL-2.1-only"
  head "https://github.com/spicetify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "010375334bbc13df70abc2df72ebde83833e1993b8aeab420386a437db147d62"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "010375334bbc13df70abc2df72ebde83833e1993b8aeab420386a437db147d62"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "010375334bbc13df70abc2df72ebde83833e1993b8aeab420386a437db147d62"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a715a62d9abbe8abd79d956544e668b723cb12a74332cf71cf4e82c27666c60"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e1e94a0550a9142b95b97dcee2779ea1856dc328a3c21c33e70bc3f36b48e17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e376ea3851c6eee248a0ff15c1414f5cd79b279699ba9d173317ae65b84c237a"
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
