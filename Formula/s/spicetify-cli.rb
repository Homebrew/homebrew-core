class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https://github.com/spicetify/spicetify-cli"
  url "https://github.com/spicetify/spicetify-cli/archive/refs/tags/v2.35.1/v2.35.1.tar.gz"
  sha256 "63a7485cfcc2ac74ce274ebac95b35d0de01b8d56bb7619d0dbe66aa87bc3720"
  license "LGPL-2.1-only"
  head "https://github.com/spicetify/spicetify-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4434806743dcae6914ed542f4b7da0c97ad4460f9eee1145a0d83894899ae989"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d5bddcc36b612ee71aea2c7c0c204da9370384e07c60f2bffcfea6d3fd5f75f3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6e62f9dc85803cf7ab57e2f9d0387687bc683f6a91e9bcee18e3313aace71c3"
    sha256 cellar: :any_skip_relocation, sonoma:         "6464acfb10076699276ac46fe2999cbe35ece58a72ecee5105ab20198194a502"
    sha256 cellar: :any_skip_relocation, ventura:        "123847e07f9b80ffcc548f638962262074e54925f568b8848349b06ce72ab45a"
    sha256 cellar: :any_skip_relocation, monterey:       "43906fd12c528bd5bc4bef0304b9a3cf0d0fd5b48f6285bd161a9b66ef6d6681"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4f50c99110932a94a00492413fff994faf35ea5c83bdeb7dcce15ca26cfeba4"
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
