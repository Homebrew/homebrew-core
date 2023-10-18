class Youtubeuploader < Formula
  desc "Scripted uploads to Youtube"
  homepage "https://github.com/porjo/youtubeuploader"
  url "https://github.com/porjo/youtubeuploader/archive/refs/tags/23.05.tar.gz"
  sha256 "d495a080bc5da4a852e8f9152cdabe937c9f218985151f98ccb26542a82ef9f9"
  license "Apache-2.0"
  head "https://github.com/porjo/youtubeuploader.git", branch: "master"

  # Upstream creates stable version tags (e.g., `23.03`) before a release but
  # the version isn't considered to be released until a corresponding release
  # is created on GitHub, so it's necessary to use the `GithubLatest` strategy.
  # https://github.com/porjo/youtubeuploader/issues/169
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "12613400022d5c5481cd0b05bc9c708fb9c83678574bcbd2ab41a3e262aa9c79"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "138f798a3c67c0ed80aaaf3e09ca4faf75138ddf7d276eebbd47baef3909bb66"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "617581507d1f9dacab7214cd2eae5decf86f43150f97425fe16268415ac4c22e"
    sha256 cellar: :any_skip_relocation, sonoma:         "3c9ea047e6391296d41ecba462e46b42405b95ee420f4ed62a78d376e77e4127"
    sha256 cellar: :any_skip_relocation, ventura:        "3911380fb56b965066072e13425402b8a140c240bb0342b1dbb3cb156edfb79c"
    sha256 cellar: :any_skip_relocation, monterey:       "d4651b54eeb9f762fc83bc92042078d2313c670ee3b34b9a06b659a5c55f2bf1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e797dbff05266325ec4db596ca5726132c02d799841f4c7a4f5008c1a2a43a2"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -X main.appVersion=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/youtubeuploader"
  end

  test do
    # Version
    assert_match version.to_s, shell_output("#{bin}/youtubeuploader -version")

    # OAuth
    (testpath/"client_secrets.json").write <<~EOS
      {
        "installed": {
          "client_id": "foo_client_id",
          "client_secret": "foo_client_secret",
          "redirect_uris": [
            "http://localhost:8080/oauth2callback",
            "https://localhost:8080/oauth2callback"
           ],
          "auth_uri": "https://accounts.google.com/o/oauth2/auth",
          "token_uri": "https://accounts.google.com/o/oauth2/token"
        }
      }
    EOS

    (testpath/"request.token").write <<~EOS
      {
        "access_token": "test",
        "token_type": "Bearer",
        "refresh_token": "test",
        "expiry": "2020-01-01T00:00:00.000000+00:00"
      }
    EOS

    output = shell_output("#{bin}/youtubeuploader -filename #{test_fixtures("test.m4a")} 2>&1", 1)
    assert_match 'oauth2: "invalid_client" "The OAuth client was not found."', output
  end
end
