class Youtubeuploader < Formula
  desc "Scripted uploads to Youtube"
  homepage "https://github.com/porjo/youtubeuploader"
  url "https://github.com/porjo/youtubeuploader/archive/refs/tags/23.06.tar.gz"
  sha256 "54161eac7efc92dba00ad98a92bfd9e067bdf7cd7208d370e0e0e4bf58faa105"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "00e2f57d95d1d1e1ed9121fcdb0b102439eff1b1380e774aa9b8a6c8a75fe5e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a365567c1261346db06e357fec2601b195366fe4f24e2cfbef0eb9574bb345b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72f018aac8b9426d338e742a738966ff5dbbb13e3d4574410a20e5dce3e56afa"
    sha256 cellar: :any_skip_relocation, sonoma:         "ad0fc6dd9921f37d9bc6f7688f07967e1caf71632c294c7e5c03943f698c0f66"
    sha256 cellar: :any_skip_relocation, ventura:        "5e981f04e18660e5412de166bb2d3651ad1f6c35ccbe2cce5e7ad5fbe9ab6d51"
    sha256 cellar: :any_skip_relocation, monterey:       "232d655d50aab5fd052b9ed160bf85be919d466597ff3b3bd16c4e05e424f451"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10b0774ac2da5a45cfc772cc2fefef188dfae5640ee325080d025fb5a137a23a"
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
