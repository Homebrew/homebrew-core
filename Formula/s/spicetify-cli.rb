class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https://github.com/spicetify/spicetify-cli"
  url "https://github.com/spicetify/spicetify-cli/archive/refs/tags/v2.28.1/v2.28.1.tar.gz"
  sha256 "62b866cf2175f174eb2c878a3cec86479df0348f1058a49f2886b39ebcc46b45"
  license "LGPL-2.1-only"
  head "https://github.com/spicetify/spicetify-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d07ad647aa227bab55a1d6a097e9b8775e05f684c07d05d26bd1885a5a705ce6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fc9fa0ea3bff05e79395c11b7403e02a423dbdfbcf49fa2ecddd507fe194c574"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ffb8ae9abe929e19d4f2a24e3a5b0c9afb00da2f052cd3b11731f040c264b93"
    sha256 cellar: :any_skip_relocation, sonoma:         "347c45695b92b296a8d331231b127175e057d83319044c37c251c15431f83118"
    sha256 cellar: :any_skip_relocation, ventura:        "b5a89fbbbad1daaf82a87589d628790dab57354dca44265cd6a4470efa871fec"
    sha256 cellar: :any_skip_relocation, monterey:       "3ab227af78845e342d27732ca5ed932bac4075f2618dc6cbd1ce0622a7ec629b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4eb9ce65bd917cdabc6a550773d9279368176ca3259695ce6da0d4b48a22c03"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags, output: libexec/"spicetify")
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
