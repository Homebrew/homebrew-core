class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https://spicetify.app/"
  url "https://github.com/spicetify/cli/archive/refs/tags/v2.40.6/v2.40.6.tar.gz"
  sha256 "ca4e0c24f7077d9a43727ad63040d317ae9be39b167cdad010ed347ac28b2fd6"
  license "LGPL-2.1-only"
  head "https://github.com/spicetify/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "813c1dc7dabc80d6489f2793f89551e0d17be26caf7254d0ddb34338228e49da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "813c1dc7dabc80d6489f2793f89551e0d17be26caf7254d0ddb34338228e49da"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "813c1dc7dabc80d6489f2793f89551e0d17be26caf7254d0ddb34338228e49da"
    sha256 cellar: :any_skip_relocation, sonoma:        "f74c649b8fa0329ca7dd043d199bc1acee34f547d1ff96c7116ec73e1a43838e"
    sha256 cellar: :any_skip_relocation, ventura:       "f74c649b8fa0329ca7dd043d199bc1acee34f547d1ff96c7116ec73e1a43838e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21f423d4be7a19d3c8f1da9336c602ad853ccf57ca601f6d1b6eb82db3741be9"
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
