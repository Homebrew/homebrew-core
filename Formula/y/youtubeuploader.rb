class Youtubeuploader < Formula
  desc "Scripted uploads to Youtube"
  homepage "https://github.com/porjo/youtubeuploader"
  url "https://github.com/porjo/youtubeuploader/archive/refs/tags/v1.25.5.tar.gz"
  sha256 "b6475f3c7553b83ac1e61d4e9ab2a4c7bec502a15675a504d87323d2cf1c3884"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3748a5d2beaafce8110971addbdb5d62a6a59867d283a88bd6672e6a5fff6622"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a21f5ff5cd30df2a734ce17d67634b114fdf9261465f27531d1b31bd402c870e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a21f5ff5cd30df2a734ce17d67634b114fdf9261465f27531d1b31bd402c870e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a21f5ff5cd30df2a734ce17d67634b114fdf9261465f27531d1b31bd402c870e"
    sha256 cellar: :any_skip_relocation, sonoma:        "94dcbcc952e28af9f60fc95201c0be744a9552f1e8ca408445801a3d8d9c7c99"
    sha256 cellar: :any_skip_relocation, ventura:       "94dcbcc952e28af9f60fc95201c0be744a9552f1e8ca408445801a3d8d9c7c99"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b1fafe8f133cec0e3edb03685b3f7ca8bee3544941075d46dfb333745ea8044"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "612d71e27119ecb79aaa4460ec721cb19b08c925e2e045730f0b6468c86e3265"
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
    assert_match 'oauth2: \"invalid_client\" \"The OAuth client was not found.\"', output
  end
end
