class Tbls < Formula
  desc "CI-Friendly tool to document a database"
  homepage "https://github.com/k1LoW/tbls"
  url "https://github.com/k1LoW/tbls/archive/refs/tags/v1.91.0.tar.gz"
  sha256 "6d9c595151db917c0eaf3bc7dd86c19cba3f19d1890bc490ace15699d33d445d"
  license "MIT"
  head "https://github.com/k1LoW/tbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3ace80665a1a3cbc44e9cbb19fc7c85ef42e71ed64bef25595d1423e0fc0362d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "31d3a6bbc6461d272e4afd26739c3602c85dbecf680215d1043b41fbf748a14c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e4017c4e84b7f30512d11c531c3882022b5ec54cd017273f9f89a421296c332"
    sha256 cellar: :any_skip_relocation, sonoma:        "633e3270a26de69b1b2c0c6c4234423f94aa5de7ee07d42ab5f61bb9acef8ff6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7207c06498a2ebe7f45853c15f26bebdae7879d14bc04b4d5491b970bf6f7e20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39c0558af1fefb884f053b6defcf34fb5d1d6d9ee36d6bd248e6b861876f629b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/k1LoW/tbls.version=#{version}
      -X github.com/k1LoW/tbls.date=#{time.iso8601}
      -X github.com/k1LoW/tbls/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"tbls", "completion")
  end

  test do
    assert_match "unsupported driver", shell_output("#{bin}/tbls doc", 1)
    assert_match version.to_s, shell_output("#{bin}/tbls version")
  end
end
