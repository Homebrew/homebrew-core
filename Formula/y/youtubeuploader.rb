class Youtubeuploader < Formula
  desc "Scripted uploads to Youtube"
  homepage "https://github.com/porjo/youtubeuploader"
  url "https://github.com/porjo/youtubeuploader/archive/refs/tags/23.04.tar.gz"
  sha256 "e9c0e6fbcbacbeed8da144bdd4ffddda17af3920ad926a18335751a2381800d7"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b2ba8f552c53485e7776fd4770a77af1563cf307692789fb3c3073247606880e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eb885f2aa0f97581196389c3d70c6408b53246928151fe700b2089b27bcff5f5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5cfa84c58e4ffdcdecc75029ad7da0dcb82b1ccf2f88d5e50e18c84939fe3f6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e6f56757e52c3c6f35a95b52d8f88bdcf01d004f344305fc71a86d24914c2a71"
    sha256 cellar: :any_skip_relocation, sonoma:         "ab0f7894d2a81faade81ef677ddef933178494cae6a65962a5059fd8626c84b6"
    sha256 cellar: :any_skip_relocation, ventura:        "f6d65ef2ee100b76931d0f0e066e6bb3092684024ac124257ecd52f314312551"
    sha256 cellar: :any_skip_relocation, monterey:       "7351f7d2babeec6ba9b8ee485751f0b34074d6869e3950a71b69ae2c03824666"
    sha256 cellar: :any_skip_relocation, big_sur:        "d7b0ac20ddebcfa11996a93d90cdf0ac3ad67430d8f3a3b35e4f23882625802b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "114a5c8ed3a8b97c19fe9348ffbd69fe4294619244c6d4d7363ad9ab1fa4cffb"
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
