class Youtubeuploader < Formula
  desc "Scripted uploads to Youtube"
  homepage "https://github.com/porjo/youtubeuploader"
  url "https://github.com/porjo/youtubeuploader/archive/refs/tags/v1.25.1.tar.gz"
  sha256 "729d3cb5a6ff6a09742d9d9371a9c84fc21961d972c24694abed3b048c3d1b83"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "634979e6eda2d78597ba78ca2cbf1e0ada4fc0a1a81260ae42391180f789c6a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "634979e6eda2d78597ba78ca2cbf1e0ada4fc0a1a81260ae42391180f789c6a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "634979e6eda2d78597ba78ca2cbf1e0ada4fc0a1a81260ae42391180f789c6a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "520ebb066a5ec08194412e8e39d4f87a71219819fee9430b55a0b1cd827afe4c"
    sha256 cellar: :any_skip_relocation, ventura:       "520ebb066a5ec08194412e8e39d4f87a71219819fee9430b55a0b1cd827afe4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11ba164d7f1330bb97cb6a0d62709577d9cf213bf05dd9adda1ff4c301477790"
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
