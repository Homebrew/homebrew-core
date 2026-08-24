class Zero < Formula
  desc "Terminal coding agent you own"
  homepage "https://zero.gitlawb.com/"
  url "https://github.com/Gitlawb/zero/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "5ceef2a00c1ba3a50e564f25c079d2cab7ebda4984761122a5e45b7aa45b4342"
  license "MIT"
  head "https://github.com/Gitlawb/zero.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "799246fc0f2a1db9fdfa888654bce463ad1ffbe0c45fda6927f0c1fdecd8881a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "799246fc0f2a1db9fdfa888654bce463ad1ffbe0c45fda6927f0c1fdecd8881a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "799246fc0f2a1db9fdfa888654bce463ad1ffbe0c45fda6927f0c1fdecd8881a"
    sha256 cellar: :any_skip_relocation, sonoma:        "77ceed32553bdc61a0aeab8e1f7ad7fcd68cb53b15fddc84d7da8cdaf36a690e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e6341741e994e1b1130d0d525b45f91acdabd9f77e7fd8dfed0d0f8d3bcdfde8"
    sha256 cellar: :any,                 x86_64_linux:  "b1c1c2fa3892f6b6d49a4d765361fa483696f82cc8ff51a8dd1095b49ba1c6e9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[-X github.com/Gitlawb/zero/internal/cli.version=#{version}]
    system "go", "build", *std_go_args(ldflags:), "./cmd/zero"
  end

  test do
    (testpath/"cmd").mkpath
    (testpath/"cmd/main.go").write <<~GO
      package main

      func main() {}
    GO

    assert_match version.to_s, shell_output("#{bin}/zero --version")

    output = shell_output("#{bin}/zero repo-map --max-files 3 --max-depth 2")
    assert_match "Repo map", output
    assert_match "cmd/main.go", output
  end
end
