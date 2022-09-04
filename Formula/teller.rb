class Teller < Formula
  desc "Secrets management tool for developers built in Go"
  homepage "https://tlr.dev/"
  url "https://github.com/SpectralOps/teller.git",
      tag:      "v1.5.5",
      revision: "97ef49b9e9129caefff7c3c74ac851a5d489415e"
  license "Apache-2.0"
  head "https://github.com/SpectralOps/teller.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad7cb09cd7fef2c58e3a333e46ba710f9543a36b4d4913246815ae5833e9efa2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "81180893ff0684163780d7dc2873c403bc847d112e7c632c9ab89045765dfade"
    sha256 cellar: :any_skip_relocation, monterey:       "981bc949eaa0470ce8f0d87460d99c8020133696caa5cf50ebaeaacf890d3337"
    sha256 cellar: :any_skip_relocation, big_sur:        "16a1e2b94d2b0f2166855623e3e2297bf5c9687fd4ebbbec54e4e092b007fb29"
    sha256 cellar: :any_skip_relocation, catalina:       "7b9d74e4688ba845289f8cdd367fb4bf727b46a2f65b28591c250ac1af7d59fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59b79e46fbc57233e193484ac640632f59e0ec3450218153ff22aeca6d670bd6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    (testpath/"test.env").write <<~EOS
      foo: var
    EOS

    (testpath/".teller.yml").write <<~EOS
      project: brewtest
      providers:
        # this will fuse vars with the below .env file
        # use if you'd like to grab secrets from outside of the project tree
        dotenv:
          env_sync:
            path: #{testpath}/test.env
    EOS

    output = shell_output("#{bin}/teller -c #{testpath}/.teller.yml show  2>&1")
    assert_match "teller: loaded variables for brewtest using #{testpath}/.teller.yml", output
    assert_match "foo", output

    assert_match "Teller #{version}", shell_output("#{bin}/teller version")
  end
end
