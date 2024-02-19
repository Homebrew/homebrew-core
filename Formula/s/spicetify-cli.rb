class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https://github.com/spicetify/spicetify-cli"
  url "https://github.com/spicetify/spicetify-cli/archive/refs/tags/v2.31.3/v2.31.3.tar.gz"
  sha256 "572a02c8fcba9984946868a011d5aee51585014a85522eea8a57365533fb67e1"
  license "LGPL-2.1-only"
  head "https://github.com/spicetify/spicetify-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4b379bcbaa9f71716e45bd46f669df520748c0238dda90326efa25aac5b1d5d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "daf97108b8353203c54c0a2b9f3bef4526e91e6a065b3b6a63ab2c28c5c8bbc0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2890b447262c1e9084a7cc5798db9d4552c3767d6b8c5898732e69be7d56a6f1"
    sha256 cellar: :any_skip_relocation, sonoma:         "b2458baa8ffd7ada14277cc8ed7c51a29efa93a2b293fb1e4dde73818c71384b"
    sha256 cellar: :any_skip_relocation, ventura:        "33018cc24fa9b0aa9c86c2a2ac764aee53003b8ecafc3d20508aa5dd6c92b5b0"
    sha256 cellar: :any_skip_relocation, monterey:       "acf0aabc6f8b4b506d5bdb048727750a8a441c8c4b6891a34e20e68c311e72a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45111b7a6b94ca3454d95cefb9a177a147e6c528f61d1ba82089ba386a4a7939"
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
