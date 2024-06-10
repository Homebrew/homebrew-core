class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https://github.com/spicetify/spicetify-cli"
  url "https://github.com/spicetify/spicetify-cli/archive/refs/tags/v2.36.12/v2.36.12.tar.gz"
  sha256 "dfaa968ade8359124cc8f59bd39b00be68a551fedbe95e1d7f79543c5141cc25"
  license "LGPL-2.1-only"
  head "https://github.com/spicetify/spicetify-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e18976dacf25c2bbc091b16c8d2c392f61d4e4579b05ac0ec24e7664162b5a1d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b13e2784588991f2ecefba057d8bf6b5cc2cadfb90858d8affb8fb3c7cd933c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a4e63203effcbfb298cf2dc8004df381724fd16ecc11fac95744f5ac9188283e"
    sha256 cellar: :any_skip_relocation, sonoma:         "b1af4924ea06c1f9174b073de59ed6ecb7089cb644040878504d9b29032ba2d2"
    sha256 cellar: :any_skip_relocation, ventura:        "c0b39674fd45e7f015784b586986084d35683b97750bbdbaa76ab194982931df"
    sha256 cellar: :any_skip_relocation, monterey:       "55c741b69355fa4f66aebb106e42e347612787af0a43cffa08d3efd55ac09522"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "baed9bff703bd7edc86b56924d97e6bbf1b7a9e5b52a5f99a9fb6d1cb0ad69f3"
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
