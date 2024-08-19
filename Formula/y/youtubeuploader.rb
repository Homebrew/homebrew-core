class Youtubeuploader < Formula
  desc "Scripted uploads to Youtube"
  homepage "https://github.com/porjo/youtubeuploader"
  url "https://github.com/porjo/youtubeuploader/archive/refs/tags/24.01.tar.gz"
  sha256 "dbcfd5dfae58bcd0b7c691b79b56800e8ce3ff140909061d00e5173cb0ed205f"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d9f9880a34bca1a12df46691445e342eb873c2b9d2f4ede24fc993af0cf87409"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "69fc55023c63fcc5e239dcae727528475f98e2505a020a3b272da725677bbf18"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cca8b4af55bf8869438269a392c9ee21d9b69330cd089f6121eb20e2ff513719"
    sha256 cellar: :any_skip_relocation, sonoma:         "6db5554737f95badc43cd766a9520a6775527ae38ea79f1f1f48cac4472322f6"
    sha256 cellar: :any_skip_relocation, ventura:        "bada1bbce066c8221938f972e04a576f2894e16f9a4c1f5e58dbab186ba286cb"
    sha256 cellar: :any_skip_relocation, monterey:       "ed93912d8531ffd24f621eedec0b7d503d1f6711d95a7d754b5c529bb227c139"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "875badff68989015fc182c516c65fc6ab8c6292f601ec8d021a6b8686232fd7a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -X main.appVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/youtubeuploader"
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
