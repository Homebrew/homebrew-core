class Youtubeuploader < Formula
  desc "Scripted uploads to Youtube"
  homepage "https://github.com/porjo/youtubeuploader"
  url "https://github.com/porjo/youtubeuploader/archive/refs/tags/23.03.tar.gz"
  sha256 "5cf1e4a410b92e920be7802ea2de59882395d529029fae2144bb72ed78aaca91"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9cdf103155413dbd4cc2b00694a1e0dede66e4cfb4bf764015dee6fb9e566213"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ede347398a7f3a607847f7607145d23bd3272e62a885ba3967486bc5e0f4c58a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d338a1b2ab8b237c74737895f101f410f8b8c9d9e1870dcd33c473c24a1e9d17"
    sha256 cellar: :any_skip_relocation, ventura:        "bdb014fd44c8fc8adf4be270a3034987e7f1482cfb649c9c2e8e9fbb837c870b"
    sha256 cellar: :any_skip_relocation, monterey:       "5f9b3aedbd6faf2be3372cadad640c1860ce7bc9592cfbae0bdb9745cad752ac"
    sha256 cellar: :any_skip_relocation, big_sur:        "bc78cd74ef2c8dd987abe9ad2eb040bc67c88a5c09985148d4996ed8fce8307d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dcef4bda69826b77e7605095b374b5ef5c8f6462765038cf2a2bb9269145b835"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -X main.appVersion=#{version}")
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
