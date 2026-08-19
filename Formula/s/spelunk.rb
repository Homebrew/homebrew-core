class Spelunk < Formula
  desc "Retrieve secrets from various sources using unified coordinates"
  homepage "https://github.com/detro/spelunk"
  url "https://github.com/detro/spelunk/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "0ad4c0182b9e036e7e5c99676dc999b9171d97872e232a2a014b2249c78a2ee5"
  license "MIT"
  head "https://github.com/detro/spelunk.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/detro/spelunk/cmd/spelunk/internal/cli.name=#{name}
      -X github.com/detro/spelunk/cmd/spelunk/internal/cli.version=#{version}
      -X github.com/detro/spelunk/cmd/spelunk/internal/cli.branch=main
      -X github.com/detro/spelunk/cmd/spelunk/internal/cli.date=#{time.iso8601}
      -X github.com/detro/spelunk/cmd/spelunk/internal/cli.builtBy=Homebrew
    ]
    cd "cmd/spelunk" do
      system "go", "build", *std_go_args(ldflags:)
    end

    generate_completions_from_executable(bin/"spelunk", "completion", "-c")
  end

  test do
    assert_match "Version: #{version}", shell_output("#{bin}/spelunk --help")

    assert_equal "test_secret", shell_output("#{bin}/spelunk base64://dGVzdF9zZWNyZXQ=")

    (testpath/"secret.json").write <<~JSON
      {"key": "json_secret"}
    JSON
    assert_equal "json_secret", shell_output("#{bin}/spelunk 'file://#{testpath}/secret.json?jp=$.key'")

    assert_equal "encoded_secret", shell_output("#{bin}/spelunk 'plain://ZW5jb2RlZF9zZWNyZXQ=?b64d'")
  end
end
