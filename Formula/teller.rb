class Teller < Formula
  desc "Secrets management tool for developers built in Go"
  homepage "https://tlr.dev/"
  url "https://github.com/SpectralOps/teller.git",
      tag:      "v1.5.6",
      revision: "7b714bc2f1d5e14920f2add828fdf7425148ff6b"
  license "Apache-2.0"
  head "https://github.com/SpectralOps/teller.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2a875942f57f04f5a95cc6df0d438b45ac409a5a0a9707b559b262f28700d1f0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c978fe39f20ae250c838865ebe9aeb58d6999862f32f80d256ea7a2d42a6697"
    sha256 cellar: :any_skip_relocation, monterey:       "c73ded881c6a0eac5970b01006026e8ab6c94dbe69037a7486cf1264f4ced60a"
    sha256 cellar: :any_skip_relocation, big_sur:        "7db5bc61d796e7eafee59050a68571c345b0f1b24e3d4cede371701f34cc19b9"
    sha256 cellar: :any_skip_relocation, catalina:       "4b5d533b017988137038cf1382f4a2b9fd12de5bf6994be1be3309f0a8866657"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4432101033c78c20387cfadb0ff4fd740bcd95c8bc6ec90b1a7cad316fef8d8c"
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
