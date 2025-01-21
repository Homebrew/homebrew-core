class Youtubeuploader < Formula
  desc "Scripted uploads to Youtube"
  homepage "https://github.com/porjo/youtubeuploader"
  url "https://github.com/porjo/youtubeuploader/archive/refs/tags/v1.24.4.tar.gz"
  sha256 "2409b0bb2f622eacba38794d24839318496e910ce33ddf2c8a139e17887b1087"
  license "Apache-2.0"
  version_scheme 1
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "306d23232c8eecb0705f0a5f0ad360a0149480f890059fb2d686b11e72b6f108"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "306d23232c8eecb0705f0a5f0ad360a0149480f890059fb2d686b11e72b6f108"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "306d23232c8eecb0705f0a5f0ad360a0149480f890059fb2d686b11e72b6f108"
    sha256 cellar: :any_skip_relocation, sonoma:        "f7cb2de9e8a4ba10fc55a271cd5c7de7e62913269c376427e050d5a0b2dc62a7"
    sha256 cellar: :any_skip_relocation, ventura:       "f7cb2de9e8a4ba10fc55a271cd5c7de7e62913269c376427e050d5a0b2dc62a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f48418f9540c2469c963192e3c15d914346900aad522cf144fe23f1a9e19b000"
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
    (testpath/"client_secrets.json").write <<~JSON
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
    JSON

    (testpath/"request.token").write <<~JSON
      {
        "access_token": "test",
        "token_type": "Bearer",
        "refresh_token": "test",
        "expiry": "2020-01-01T00:00:00.000000+00:00"
      }
    JSON

    output = shell_output("#{bin}/youtubeuploader -filename #{test_fixtures("test.m4a")} 2>&1", 1)
    assert_match 'oauth2: "invalid_client" "The OAuth client was not found."', output
  end
end
