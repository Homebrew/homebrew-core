class Tbls < Formula
  desc "CI-Friendly tool for document a database"
  homepage "https://github.com/k1LoW/tbls"
  url "https://github.com/k1LoW/tbls/archive/refs/tags/v1.56.3.tar.gz"
  sha256 "ca4ce36a4ecb7896385935ea381cf2a4d74bf9a210e1c6fa660329cc6cc7daf3"
  license "MIT"
  head "https://github.com/k1LoW/tbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "32b742267f1aaee9c4e3dd64a86b58788f5bab8742cf1f01cec752f0c9bf202a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bd269f39f34877371f3372723b3cd89f9aceb2a229eba4ba7eb2758ec1da66e3"
    sha256 cellar: :any_skip_relocation, monterey:       "20f8011fb2ddbb1d571e72b8fb1e52ea14f4e026f5980091d8e702dad226f7a5"
    sha256 cellar: :any_skip_relocation, big_sur:        "1625446230563db9856b4e0db8889adf331aec3be617bd7a850b9a398f1588b8"
    sha256 cellar: :any_skip_relocation, catalina:       "d9596755908e57fd6751ac100210bc43787de0b6d9be57c3d52bb9f5616538bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b33074594781bc528fff8d65f14b8fb3a7da09530da468ee75c1c02aaea9ffb2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/k1LoW/tbls.version=#{version}
      -X github.com/k1LoW/tbls.date=#{time.rfc3339}
      -X github.com/k1LoW/tbls/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"tbls", "completion")
  end

  test do
    assert_match "invalid database scheme", shell_output(bin/"tbls doc", 1)
    assert_match version.to_s, shell_output(bin/"tbls version")
  end
end
