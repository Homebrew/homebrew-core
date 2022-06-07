class Teller < Formula
  desc "Secrets management tool for developers built in Go"
  homepage "https://tlr.dev/"
  url "https://github.com/SpectralOps/teller.git",
      tag:      "v1.5.1",
      revision: "6c67edf1419066fb7e75d487b06b4e43f1646060"
  license "Apache-2.0"
  head "https://github.com/SpectralOps/teller.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e03506d29d84ca8f1fb3c5879431565685f97177959d121482c7db7f826014ee"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "911c4a04c20d3a8bec9536f4ad8dc11f030979602d961b418a0d96b12969c738"
    sha256 cellar: :any_skip_relocation, monterey:       "92590bab2b1e69c0a48846611f3cf1e0a499998e3aeacd9d81c5f184fbdd0ad4"
    sha256 cellar: :any_skip_relocation, big_sur:        "8abb8a4cab114295de4eed3acaa37aa22ee7b89a59808f0c8a8bdaad5a61f4cd"
    sha256 cellar: :any_skip_relocation, catalina:       "19abfa6a5deba36d232ba4560b3ddd67e4cb1ca289d0f1b3d15d0ff61c539aa0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76c90f4033c77db399e97c9d4cc18a924ed1d5b62506eb2caa4cc8a0ec1ddaf2"
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

    output = shell_output("#{bin}/teller -c #{testpath}/.teller.yml show")
    assert_match "teller: loaded variables for brewtest using #{testpath}/.teller.yml", output
    assert_match "foo", output

    assert_match "Teller #{version}", shell_output("#{bin}/teller version")
  end
end
