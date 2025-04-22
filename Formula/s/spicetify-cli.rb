class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https://spicetify.app/"
  url "https://github.com/spicetify/cli/archive/refs/tags/v2.40.0/v2.40.0.tar.gz"
  sha256 "8b167789fb64cf87e1b74f49b28a4e500f0cbcb1228a7bcaec0253cdaf86a34a"
  license "LGPL-2.1-only"
  head "https://github.com/spicetify/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4c7646c8b7175ace64c4ef52d226e12b212000e5246a4b5447dd05d3e761321"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4c7646c8b7175ace64c4ef52d226e12b212000e5246a4b5447dd05d3e761321"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f4c7646c8b7175ace64c4ef52d226e12b212000e5246a4b5447dd05d3e761321"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a165460ae0397560e1d6852174bb5c092c28afdac6eeaa629560191b4abc8fc"
    sha256 cellar: :any_skip_relocation, ventura:       "4a165460ae0397560e1d6852174bb5c092c28afdac6eeaa629560191b4abc8fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6bae119ff3674249e422b9c55ebf57a50b28800b26ad8c0938163be991f31c7"
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
