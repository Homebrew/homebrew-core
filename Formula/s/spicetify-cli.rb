class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https://github.com/spicetify/spicetify-cli"
  url "https://github.com/spicetify/spicetify-cli/archive/refs/tags/v2.32.1/v2.32.1.tar.gz"
  sha256 "0de4b8eb7dd6157dc5c9b6eee3432227d0340c8b44ae8d0fc285a0af22b48437"
  license "LGPL-2.1-only"
  head "https://github.com/spicetify/spicetify-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4292703c8ffc60a61612279bbebf374aa51d24f303b01e87e10cd941186fc7c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e27975df9e8500f27463ed4b867651e260a78fa8773ef966bfd04f9831c7ce11"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e4232131ae99bb469925b9c998496c77e4799f83ffb353be382baf418d6c5ced"
    sha256 cellar: :any_skip_relocation, sonoma:         "ebce8f49af595fcc40cde96daf04c1c9335d141b2f61acf64bde32314ad5d948"
    sha256 cellar: :any_skip_relocation, ventura:        "fa4b3a7f4875def03a63b13126601390e0c28e48816d52fb82057cd09e17b3d8"
    sha256 cellar: :any_skip_relocation, monterey:       "062245475c7bad66a668a17bb4b32b52e330f7544b6903f8e487f257ca7f758c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "161f509329dedd1e8db82c41f84eb6beabd772ff520054640828d1084be142d5"
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
