class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https://github.com/spicetify/cli"
  url "https://github.com/spicetify/cli/archive/refs/tags/v2.37.1/v2.37.1.tar.gz"
  sha256 "9c73e72036f1f75eaebdd5c819bd17cf3b124f31e96c50ca2644a233d9839c28"
  license "LGPL-2.1-only"
  head "https://github.com/spicetify/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "062c7f86fe732c7f0acd9f82066fb2bc29a79b2e408119b5551282d805b5093a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f0a39f1a7f5717a57087f1c5998155a467e4af09f6c5af7cd253439ccd650e5f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3fe3893873384f4ade31e03ae4862b87ef29fcfc690df812e59d2d44ba113687"
    sha256 cellar: :any_skip_relocation, sonoma:         "d18bd18e9fee9dce4c8e24ba53913c2de74cff7e3402c764d694cbd9346ed22f"
    sha256 cellar: :any_skip_relocation, ventura:        "099ad452b7ea5c40a13f6d6ff70ec116b4c2ee84514311ac6e95d29713aefd71"
    sha256 cellar: :any_skip_relocation, monterey:       "2512946019ba5818ab5ac74de1adba40b00536d4675b09914fbe6e2620e7acd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e25003851c1a824f6294ecf9505dac4bf123ab6fa3937f1dda2a7dbe3bd904b8"
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
